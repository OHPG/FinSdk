import { ApiClient, ApiRequest, UserInfo } from "@ohpg/network";

/**
 * Plex API Client
 * Plex uses X-Plex-Token header for authentication
 */
export class PlexApiClient extends ApiClient {

  private userInfo?: UserInfo

  public updateUserInfo(userInfo: UserInfo) {
    this.userInfo = userInfo
  }

  private getSafeToken(): string {
    if (this.userInfo && this.userInfo.token) {
      return this.userInfo.token
    }
    return ""
  }

  protected getHeaders(request: ApiRequest): Record<string, string> {
    let header: Record<string, string> = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Plex-Client-Identifier': this.deviceInfo.id,
      'X-Plex-Product': this.clientInfo.name,
      'X-Plex-Version': this.clientInfo.version,
      'X-Plex-Device': this.deviceInfo.name,
      'X-Plex-Device-Name': this.deviceInfo.name,
      'X-Plex-Platform': 'HarmonyOS',
      'User-Agent': `${this.clientInfo.name}/${this.clientInfo.version} (HarmonyOS)`
    }
    let token = this.getSafeToken()
    if (token.length > 0) {
      header['X-Plex-Token'] = token
    }
    return header
  }

  public getAuthorization(): string {
    return ""
  }

  public getToken(): string {
    return this.getSafeToken()
  }
}
