/**
 * authx 签名所需的应用密钥。
 */
export interface FnosAuthxKey {
  apiKey: string
  apiSecret: string
  /** X-Trim-Client-Version，解析不到时由客户端使用默认值 */
  clientVersion?: string
}

/**
 * authx 密钥来源，可替换。实现不得把密钥写入日志。
 */
export interface AuthxProvider {
  resolve(baseUrl: string): Promise<FnosAuthxKey>
}
