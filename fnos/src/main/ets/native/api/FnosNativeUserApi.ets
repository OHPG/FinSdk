import { FnosNativeApiClient } from '../network/FnosNativeApiClient'
import { FnosNativeLoginData, FnosNativeLoginRequest, FnosNativeUserInfo } from '../model/FnosNativeModels'

export class FnosNativeUserApi {

  readonly apiClient: FnosNativeApiClient

  constructor(apiClient: FnosNativeApiClient) {
    this.apiClient = apiClient
  }

  /** 账号密码登录，返回 token；调用方需 updateToken 后再取用户信息。 */
  public async login(username: string, password: string): Promise<string> {
    let body: FnosNativeLoginRequest = { username: username, password: password, app_name: 'trimemedia-web' }
    let data = await this.apiClient.call<FnosNativeLoginData>('POST', '/login', undefined, body)
    return data.token
  }

  public async getUserInfo(): Promise<FnosNativeUserInfo> {
    return this.apiClient.call<FnosNativeUserInfo>('GET', '/user/info')
  }
}
