import { ApiClient, ApiRequest, UserInfo } from "@ohpg/network";

/**
 * @Author peerless2012
 * @Email peerless2012@126.com
 * @DateTime 2025/7/5 21:27
 * @Version V1.0
 * @Description
 */
export class EmbyApiClient extends ApiClient {

  private userInfo?: UserInfo

  public updateUserInfo(userInfo: UserInfo) {
    this.userInfo = userInfo
  }

  protected filterParams(request: ApiRequest): object | undefined {
    let result = super.filterParams(request)
    if (!result) {
      return undefined
    }
    let params = result as Record<string, ESObject>
    let converted: Record<string, ESObject> = {}
    Object.keys(params).forEach(key => {
      let value: ESObject = params[key]
      if (value === undefined || value === null) {
        return
      }
      let pascalKey = key.charAt(0).toUpperCase() + key.slice(1)
      if (Array.isArray(value)) {
        let values = new Array<string>()
        value.forEach((v: ESObject) => {
          if (v !== undefined && v !== null && v !== '') {
            values.push(String(v))
          }
        })
        if (values.length > 0) {
          converted[pascalKey] = values.join(',')
        }
      } else {
        converted[pascalKey] = value
      }
    })
    return converted
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
      'X-Emby-Authorization': this.buildEmbyAuthorization(false),
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
      'X-Emby-Authorization': this.buildEmbyAuthorization(true),
      'User-Agent': `${this.clientInfo.name}/${this.clientInfo.version} (HarmonyOS)`
    }
  }

  /**
   * 构建 X-Emby-Authorization 值
   * 格式参照 Emby 官方 JS SDK：MediaBrowser Client="...", Device="...", DeviceId="...", Version="...", Token="..."
   * @param includeToken 是否包含 Token（登录请求时不含）
   */
  private buildEmbyAuthorization(includeToken: boolean): string {
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
    return this.buildEmbyAuthorization(true)
  }

  private getSafeId(): string {
    if (this.userInfo && this.userInfo.id) {
      return this.userInfo.id
    }
    return ""
  }

  private getSafeToken(): string {
    if (this.userInfo && this.userInfo.token) {
      return this.userInfo.token
    }
    return ""
  }

}