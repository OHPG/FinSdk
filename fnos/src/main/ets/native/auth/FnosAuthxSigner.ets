import { FnosAuthxKey } from './AuthxProvider'
import { fnosMd5Hex } from './FnosMd5'

/** 签名用 query 键值，值为未编码原文。 */
export interface FnosQueryPair {
  key: string
  value: string
}

/**
 * authx 签名器（纯函数）。
 * sign = md5(`apiKey_path_nonce_timestamp_bodyMd5_apiSecret`)
 * - path：/v/api/v1/...，不含 host 与 query
 * - bodyMd5：有 body 取 md5(bodyJson)(须与实际发送的字符串逐字节一致)；
 *   无 body 取 query 按 key 排序、剔除空值/"null"/"undefined"后以 k=v&k=v 连接的 md5；都没有取 md5("")
 */
export class FnosAuthxSigner {

  /**
   * 剔除空值/"null"/"undefined"的 query 键值。签名与实际发送的 URL 必须共用这一份，
   * 否则服务端按收到的 query 重算时会与签名不一致。
   */
  public static filterQuery(queryPairs: FnosQueryPair[]): FnosQueryPair[] {
    return queryPairs.filter((p: FnosQueryPair) => {
      return p.value !== '' && p.value !== 'null' && p.value !== 'undefined'
    })
  }

  public static bodyDigestSource(queryPairs: FnosQueryPair[], bodyJson?: string): string {
    if (bodyJson !== undefined && bodyJson.length > 0) {
      return bodyJson
    }
    let pairs: FnosQueryPair[] = FnosAuthxSigner.filterQuery(queryPairs)
    pairs.sort((a: FnosQueryPair, b: FnosQueryPair) => a.key < b.key ? -1 : (a.key > b.key ? 1 : 0))
    return pairs.map((p: FnosQueryPair) => `${p.key}=${p.value}`).join('&')
  }

  /**
   * 生成 authx 头的值：nonce=..&timestamp=..&sign=..
   * nonce / timestamp 可注入，便于固定向量验证。
   */
  public static sign(key: FnosAuthxKey, path: string, queryPairs: FnosQueryPair[], bodyJson?: string,
    nonce?: string, timestamp?: string): string {
    let n = nonce !== undefined ? nonce : FnosAuthxSigner.randomNonce()
    let ts = timestamp !== undefined ? timestamp : `${Date.now()}`
    let bodyMd5 = fnosMd5Hex(FnosAuthxSigner.bodyDigestSource(queryPairs, bodyJson))
    let sign = fnosMd5Hex(`${key.apiKey}_${path}_${n}_${ts}_${bodyMd5}_${key.apiSecret}`)
    return `nonce=${n}&timestamp=${ts}&sign=${sign}`
  }

  private static randomNonce(): string {
    return `${Math.floor(Math.random() * 900000) + 100000}`
  }
}
