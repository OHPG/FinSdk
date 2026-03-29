import { Api } from "./Api"
import { PlexAccount } from "../model/PlexAccount"
import { PlexSignIn } from "../model/PlexSignIn"

/**
 * Plex User API
 * Authentication through plex.tv v2 API
 */
export class UserApi extends Api {

  /**
   * Sign in to plex.tv with username/password and get auth token
   * POST https://plex.tv/api/v2/users/signin?login=xxx&password=xxx
   */
  public async signIn(username: string, password: string): Promise<PlexAccount> {
    let params: PlexSignIn = {
      login: username,
      password: password
    }
    return this.apiClient.post({
      url: "https://plex.tv",
      path: "/api/v2/users/signin",
      parameters: params
    })
  }
}
