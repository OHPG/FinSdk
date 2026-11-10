import { rcp } from '@kit.RemoteCommunicationKit'
import { ApiError } from '@ohpg/network'
import { AuthxProvider, FnosAuthxKey } from './AuthxProvider'

/** 最多扫描的文件数（入口页 + 同源脚本）。Vite SPA 的懒加载 chunk 较多，上限放宽 */
const MAX_SCRIPTS = 300

/** 每批并发拉取的文件数 */
const BATCH_SIZE = 8

/** 解析失败后的冷却期：期间不重复扫描，超过后允许重试（对齐 AniBox signMaterials.ts） */
const RETRY_COOLDOWN_MS = 30000

const DEBUG_TAG = '[FnosNativeDebug]'

/**
 * 运行时从服务器公开的 /v/ 页面及其同源 JS 解析 authx 密钥，不在仓库内携带密钥。
 *
 * 解析方式参考 Lumy Player 的 FnOsNativeClient（在飞牛影视 0.8.43 上验证过）：
 * 1. 从 /v/ 开始广度优先扫描：HTML 的 src/href、JS 里的 `from"x.js"` / `import("x.js")`，
 *    相对路径按"当前文件"解析，仅限同源，最多 MAX_SCRIPTS 个文件；
 * 2. 命中同时含 `authx` 与 `nonce=` 的文件后解析：
 *    - apiKey：数组字面量 [`<apiKey>`,a,b,c,d,e].join(`_`) 的第一个元素；
 *    - apiSecret：`apiKey:<变量>` 指向的立即执行函数里，Uint8Array 逐字节异或 mask 还原；
 *    - clientVersion：`<变量>=`X-Trim-Client-Version``，再取 `[变量]:`<版本>``。
 * 正则针对压缩后的 JS，飞牛前端改版可能失效；解析失败抛错且不缓存。
 */
export class WebBootstrapAuthxProvider implements AuthxProvider {

  private cache: Map<string, FnosAuthxKey> = new Map()

  /** 解析失败的时间戳：冷却期内不重复扫描（否则每个请求都会重新拉取全部 JS） */
  private failedAt: Map<string, number> = new Map()

  /** 同一服务器的并发解析共用一个 Promise */
  private inflight: Map<string, Promise<FnosAuthxKey>> = new Map()

  public async resolve(baseUrl: string): Promise<FnosAuthxKey> {
    let base = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl
    let cached = this.cache.get(base)
    if (cached) {
      return cached
    }
    let failedAt = this.failedAt.get(base)
    if (failedAt !== undefined && Date.now() - failedAt < RETRY_COOLDOWN_MS) {
      throw new ApiError(500, 'authx key not found') as Error
    }
    let running = this.inflight.get(base)
    if (running) {
      return running
    }
    let task = this.scan(base).finally(() => {
      this.inflight.delete(base)
    })
    this.inflight.set(base, task)
    return task
  }

  private async scan(base: string): Promise<FnosAuthxKey> {
    let root = `${base}/v/`
    let session = rcp.createSession()
    let scanned = 0
    let candidates = 0
    try {
      let pending: string[] = [root]
      let visited: Set<string> = new Set()
      while (pending.length > 0 && visited.size < MAX_SCRIPTS) {
        let batch: string[] = []
        while (pending.length > 0 && batch.length < BATCH_SIZE && visited.size < MAX_SCRIPTS) {
          let url = pending.shift() as string
          if (!visited.has(url)) {
            visited.add(url)
            batch.push(url)
          }
        }
        let sources = await Promise.all(batch.map((url: string) => this.fetchOrEmpty(session, url)))
        if (batch[0] === root && sources[0].length === 0) {
          throw new ApiError(500, 'bootstrap root fetch failed') as Error
        }
        for (let i = 0; i < batch.length; i++) {
          let source = sources[i]
          if (source.length === 0) {
            continue
          }
          scanned++
          if (source.indexOf('authx') >= 0 && source.indexOf('nonce=') >= 0) {
            candidates++
          }
          let key = this.parseKey(source)
          if (key) {
            console.error(`${DEBUG_TAG} authx key resolved after scanning ${scanned} files`)
            this.cache.set(base, key)
            this.failedAt.delete(base)
            return key
          }
          this.enqueueReferences(source, batch[i], base, pending, visited)
        }
      }
    } finally {
      session.close()
    }
    console.error(`${DEBUG_TAG} authx key not found, scanned=${scanned} candidates=${candidates}`)
    this.failedAt.set(base, Date.now())
    throw new ApiError(500, `authx key not found (scanned ${scanned}, candidates ${candidates})`) as Error
  }

  private async fetchOrEmpty(session: rcp.Session, url: string): Promise<string> {
    try {
      return await this.fetchText(session, url)
    } catch (e) {
      return ''
    }
  }

  private async fetchText(session: rcp.Session, url: string): Promise<string> {
    let response = await session.get(url)
    if (response.statusCode !== 200) {
      throw new ApiError(response.statusCode, 'bootstrap fetch failed') as Error
    }
    return response.toString() || ''
  }

  /** 收集 source 里引用的同源 .js，加入待扫描队列 */
  private enqueueReferences(source: string, current: string, base: string, pending: string[],
    visited: Set<string>): void {
    // 所有以 .js 结尾的字符串字面量都视为候选引用：除了 src/href/from/import()，
    // Vite 的懒加载依赖表 __vite__mapDeps 里是裸的 "assets/x.js"，签名 chunk 往往只出现在这里
    let regex = /["'`]((?:https?:\/\/|\/|\.{1,2}\/)?[\w\-.\/]*?[\w\-]+\.js)(?:\?[^"'`]*)?["'`]/g
    let m = regex.exec(source)
    while (m !== null) {
      let ref = m[1]
      if (ref) {
        let url = this.resolveUrl(ref, current, base)
        if (url && url.indexOf('/v/') >= 0 && !visited.has(url) && !pending.includes(url)) {
          pending.push(url)
        }
      }
      m = regex.exec(source)
    }
  }

  /** 按 current 解析 ref，仅同源；返回规范化后的完整 URL */
  private resolveUrl(ref: string, current: string, base: string): string | undefined {
    if (ref.startsWith('//')) {
      return undefined
    }
    let origin = base.replace(/^(https?:\/\/[^\/]+).*$/, '$1')
    if (ref.startsWith('http://') || ref.startsWith('https://')) {
      // 比较完整 origin（协议+主机+端口），避免 http://host 误匹配 http://host.evil.com
      let refOrigin = ref.replace(/^(https?:\/\/[^\/]+).*$/, '$1')
      return refOrigin === origin ? ref : undefined
    }
    let path: string
    if (ref.startsWith('/')) {
      path = ref
    } else if (ref.startsWith('assets/')) {
      // Vite __vite__mapDeps 里的裸路径相对应用 base（/v/），不是相对当前 chunk
      let basePath = base.substring(origin.length)
      path = `${basePath}/v/${ref}`
    } else {
      let currentPath = current.substring(origin.length).split('?')[0].split('#')[0]
      path = currentPath.substring(0, currentPath.lastIndexOf('/') + 1) + ref
    }
    let segments: string[] = []
    let parts = path.split('/')
    for (let i = 0; i < parts.length; i++) {
      let part = parts[i]
      if (part === '' || part === '.') {
        continue
      }
      if (part === '..') {
        segments.pop()
      } else {
        segments.push(part)
      }
    }
    return `${origin}/${segments.join('/')}`
  }

  private escapeRegex(value: string): string {
    return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
  }

  private parseKey(js: string): FnosAuthxKey | undefined {
    if (js.indexOf('authx') < 0 || js.indexOf('nonce=') < 0) {
      return undefined
    }
    // apiKey：[`<apiKey>`,url,nonce,ts,md5,secret].join(`_`) 的第一个元素
    let appMatch = /\[`([^`]+)`,[\w$]+,[\w$]+,[\w$]+,[\w$]+,[\w$]+\]\.join\(`_`\)/.exec(js)
    // `apiKey:<变量>`：变量持有还原后的密钥
    let varMatch = /apiKey\s*:\s*([\w$]+)/.exec(js)
    if (!appMatch || !varMatch) {
      return undefined
    }
    let name = this.escapeRegex(varMatch[1])
    let iifeMatch = new RegExp(name + '=\\(\\(\\)=>\\{([\\s\\S]{1,1200}?)\\}\\)\\(\\)').exec(js)
    if (!iifeMatch) {
      return undefined
    }
    let body = iifeMatch[1]
    let bytesMatch = /new Uint8Array\(\[([\d,\s]+)\]\)/.exec(body)
    if (!bytesMatch) {
      return undefined
    }
    let maskMatch = /\[[\w$]+\]\s*=\s*[\w$]+\[[\w$]+\]\s*\^\s*(\d+)/.exec(body)
    if (!maskMatch) {
      maskMatch = /\^\s*=?\s*(\d+)/.exec(body)
    }
    if (!maskMatch) {
      return undefined
    }
    let mask = parseInt(maskMatch[1])
    let secret = ''
    let parts = bytesMatch[1].split(',')
    for (let i = 0; i < parts.length; i++) {
      let t = parts[i].trim()
      if (t.length === 0) {
        continue
      }
      let n = parseInt(t)
      if (isNaN(n) || n < 0 || n > 255) {
        return undefined
      }
      secret += String.fromCharCode(n ^ mask)
    }
    // 还原结果须是可打印 ASCII（实测为 UUID 形态）；否则说明解码器结构变了，宁可不签也不发错签
    if (secret.length < 8 || secret.length > 128 || !/^[\x20-\x7e]+$/.test(secret)) {
      console.error(`${DEBUG_TAG} authx secret decode produced unexpected value, len=${secret.length}`)
      return undefined
    }
    let key: FnosAuthxKey = { apiKey: appMatch[1], apiSecret: secret }
    let verVar = /([\w$]+)=`X-Trim-Client-Version`/.exec(js)
    if (verVar) {
      let ver = new RegExp('\\[' + this.escapeRegex(verVar[1]) + '\\]:`([^`]+)`').exec(js)
      if (ver) {
        key.clientVersion = ver[1]
      }
    }
    if (!key.clientVersion) {
      let fallback = /X-Trim-Client-Version["']?\s*[:,]\s*["']?(\d+)/i.exec(js)
      if (fallback) {
        key.clientVersion = fallback[1]
      }
    }
    return key
  }
}
