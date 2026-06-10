import { ApiClient, ApiRequest, UserInfo } from "@ohpg/network";

/**
 * @Author peerless2012
 * @Email peerless2012@126.com
 * @DateTime 2025/7/5 18:21
 * @Version V1.0
 * @Description Jellyfin api client
 */
export class JellyfinApiClient extends ApiClient {

  private userInfo?: UserInfo

  public updateUserInfo(userInfo: UserInfo) {
    this.userInfo = userInfo
  }

  protected getHeaders(request: ApiRequest): Record<string, string> {
    if (request.path.endsWith("/Users/AuthenticateByName")) {
      return this.getLoginHeader()
    } else {
      return this.getNormalHeader()
    }
  }

  /**
   * 登录请求 header：使用 X-Emby-Authorization（不含 Token）
   */
  private getLoginHeader(): Record<string, string> {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json, application/octet-stream;q=0.9, */*;q=0.8',
      'X-Emby-Authorization': this.buildAuthorization(false),
      'User-Agent': `${this.clientInfo.name}/${this.clientInfo.version} (HarmonyOS)`
    }
  }

  /**
   * 普通请求 header：使用 X-Emby-Authorization（含 Token）
   */
  private getNormalHeader(): Record<string, string> {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json, application/octet-stream;q=0.9, */*;q=0.8',
      'X-Emby-Authorization': this.buildAuthorization(true),
      'User-Agent': `${this.clientInfo.name}/${this.clientInfo.version} (HarmonyOS)`
    }
  }

  /**
   * 构建 X-Emby-Authorization 值
   * 格式：MediaBrowser Client="...", Device="...", DeviceId="...", Version="...", Token="..."
   * Jellyfin 10.12+ 默认不再支持标准 Authorization header，必须使用 X-Emby-Authorization
   * @param includeToken 是否包含 Token（登录请求时不含）
   */
  private buildAuthorization(includeToken: boolean): string {
    let values: string[] = [
      `Client="${encodeURIComponent(this.clientInfo.name)}"`,
      `Device="${encodeURIComponent(this.deviceInfo.name)}"`,
      `DeviceId="${encodeURIComponent(this.deviceInfo.id)}"`,
      `Version="${encodeURIComponent(this.clientInfo.version)}"`
    ]
    if (includeToken) {
      let token = this.getSafeToken()
      if (token) {
        values.push(`Token="${encodeURIComponent(token)}"`)
      }
    }
    return `MediaBrowser ${values.join(', ')}`
  }

  public getAuthorization(): string {
    return this.buildAuthorization(true)
  }

  private getSafeToken(): string {
    if (this.userInfo && this.userInfo.token) {
      return this.userInfo.token
    }
    return ""
  }

}