import { ApiClient, ApiRequest, UserInfo } from "@ohpg/network";

/**
 * fnOS 兼容模式 HTTP 客户端。
 * 认证头同 Emby：X-Emby-Authorization + X-Emby-Token。
 * 登录与后续所有请求（含播放、图片）都使用同一个 deviceInfo.id（服务端按 DeviceId 绑定 token）。
 */
export class FnosApiClient extends ApiClient {

  private userInfo?: UserInfo

  public updateUserInfo(userInfo: UserInfo) {
    this.userInfo = userInfo
  }

  public getUserId(): string {
    return this.userInfo?.id || ""
  }

  public getToken(): string {
    return this.userInfo?.token || ""
  }

  public getDeviceId(): string {
    return this.deviceInfo.id
  }

  public getAuthorization(): string {
    return this.buildAuthorization()
  }

  /**
   * 认证头集合，供图片 / 播放（FinImage.header、播放器 header）复用。
   */
  public getAuthHeaders(): Record<string, string> {
    let headers: Record<string, string> = {
      'X-Emby-Authorization': this.buildAuthorization(),
      'User-Agent': `${this.clientInfo.name}/${this.clientInfo.version} (HarmonyOS)`
    }
    let token = this.getToken()
    if (token) {
      headers['X-Emby-Token'] = token
    }
    return headers
  }

  protected getHeaders(request: ApiRequest): Record<string, string> {
    let headers = this.getAuthHeaders()
    headers['Content-Type'] = 'application/json'
    headers['Accept'] = 'application/json'
    return headers
  }

  private buildAuthorization(): string {
    let values: string[] = [
      `Client="${this.headerSafe(this.clientInfo.name)}"`,
      `Device="${this.headerSafe(this.deviceInfo.name)}"`,
      `DeviceId="${this.headerSafe(this.deviceInfo.id)}"`,
      `Version="${this.headerSafe(this.clientInfo.version)}"`
    ]
    let token = this.getToken()
    if (token) {
      values.push(`Token="${token}"`)
    }
    return `MediaBrowser ${values.join(', ')}`
  }

  /**
   * 去掉引号、逗号和非 ASCII 字符（与 Lumy 的 headerSafe 一致）。
   */
  private headerSafe(value: string): string {
    let result = ''
    for (let i = 0; i < value.length; i++) {
      let code = value.charCodeAt(i)
      if (code >= 32 && code <= 126 && code !== 34 && code !== 44) {
        result += value.charAt(i)
      }
    }
    return result.length > 0 ? result : 'HarmonyOS'
  }
}
