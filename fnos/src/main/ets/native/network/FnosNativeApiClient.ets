import { ApiClient, ApiError, ApiRequest, ClientInfo, DeviceInfo } from '@ohpg/network'
import { AuthxProvider, FnosAuthxKey } from '../auth/AuthxProvider'
import { FnosAuthxSigner, FnosQueryPair } from '../auth/FnosAuthxSigner'
import { WebBootstrapAuthxProvider } from '../auth/WebBootstrapAuthxProvider'
import { FnosNativeResponse } from '../model/FnosNativeModels'

const API_PREFIX = '/v/api/v1'
const DEFAULT_CLIENT_VERSION = '616'

/**
 * 飞牛原生模式 HTTP 客户端：所有请求走 rcp(sendRaw)，body 以 JSON.stringify 的字符串原样发送并参与签名。
 * 不记录 token / 密钥。
 */
export class FnosNativeApiClient extends ApiClient {

  private token: string = ''
  private authxProvider: AuthxProvider
  private clientVersion: string = DEFAULT_CLIENT_VERSION
  /** 每个请求对应的 authx 头；getHeaders 在 sendRaw 同步段内读取。 */
  private pendingAuthx: Map<ApiRequest, string> = new Map()

  constructor(clientInfo: ClientInfo, deviceInfo: DeviceInfo, provider?: AuthxProvider) {
    super(clientInfo, deviceInfo)
    this.authxProvider = provider ? provider : new WebBootstrapAuthxProvider()
  }

  public updateToken(token: string) {
    this.token = token
  }

  public getToken(): string {
    return this.token
  }

  public getAuthorization(): string {
    return this.token
  }

  public setAuthxProvider(provider: AuthxProvider) {
    this.authxProvider = provider
  }

  public getBase(): string {
    let address = this.getServer()?.address || ''
    return address.endsWith('/') ? address.slice(0, -1) : address
  }

  /** 图片 / 播放使用的静态头：Authorization + Cookie + User-Agent。 */
  public getMediaHeaders(): Record<string, string> {
    let headers: Record<string, string> = {
      'User-Agent': `${this.clientInfo.name}/${this.clientInfo.version} (HarmonyOS)`
    }
    if (this.token) {
      headers['Authorization'] = this.token
      // 对齐 AniBox：始终带 mode=relay，直连与 FN Connect 中继都兼容
      headers['Cookie'] = `mode=relay; Trim-MC-token=${this.token}`
    }
    return headers
  }

  /**
   * 飞牛约定带 body 的请求（POST/PUT/PATCH/DELETE）在 body 末尾追加 6 位 nonce 防重放，
   * 签名按追加后的最终字符串计算（对齐 AniBox fnapi.rs / Fntv-Plus request.ts）。
   */
  private static appendNonce(json: string): string {
    let nonce = `${Math.floor(100000 + Math.random() * 900000)}`
    if (!json.startsWith('{') || !json.endsWith('}')) {
      return json
    }
    let separator = json.length > 2 ? ',' : ''
    return `${json.substring(0, json.length - 1)}${separator}"nonce":"${nonce}"}`
  }

  protected getHeaders(request: ApiRequest): Record<string, string> {
    let headers = this.getMediaHeaders()
    headers['x-trim-client'] = 'web'
    headers['x-trim-client-version'] = this.clientVersion
    headers['Accept'] = 'application/json'
    headers['Content-Type'] = 'application/json'
    let authx = this.pendingAuthx.get(request)
    if (authx) {
      headers['authx'] = authx
    }
    return headers
  }

  /**
   * @param endpoint 相对 /v/api/v1 的路径，如 '/item/list'
   * @param query 未编码键值，签名与发送共用
   * @param body 不为空时 JSON.stringify 后发送并签名
   */
  public async call<T>(method: string, endpoint: string, query?: FnosQueryPair[], body?: object): Promise<T> {
    let path = `${API_PREFIX}${endpoint}`
    let pairs: FnosQueryPair[] = query ? query : []
    let bodyJson: string | undefined = body !== undefined
      ? FnosNativeApiClient.appendNonce(JSON.stringify(body)) : undefined
    // 签名材料是可选的（对齐 AniBox）：取不到时不带 authx 头，请求照常发出，
    // 由网关按未签名处理；大部分影视接口不强制签名。
    let authx: string | undefined
    try {
      let key: FnosAuthxKey = await this.authxProvider.resolve(this.getBase())
      if (key.clientVersion) {
        this.clientVersion = key.clientVersion
      }
      authx = FnosAuthxSigner.sign(key, path, pairs, bodyJson)
    } catch (e) {
      authx = undefined
    }
    let url = path
    let valid = FnosAuthxSigner.filterQuery(pairs)
    if (valid.length > 0) {
      url += '?' + valid.map((p: FnosQueryPair) => `${encodeURIComponent(p.key)}=${encodeURIComponent(p.value)}`).join('&')
    }
    let request: ApiRequest = { path: url, rawBody: bodyJson }
    if (authx) {
      this.pendingAuthx.set(request, authx)
    }
    let response: FnosNativeResponse<T>
    try {
      response = await this.sendRaw<FnosNativeResponse<T>>(request, method)
    } finally {
      this.pendingAuthx.delete(request)
    }
    if (response === undefined || response === null) {
      return undefined as T
    }
    if (response.code !== 0) {
      throw new ApiError(response.code, response.msg || 'request failed') as Error
    }
    return response.data as T
  }
}
