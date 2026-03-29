import { Api } from "./Api"
import { PlexResponse } from "../model/PlexMediaContainer"

export class SystemApi extends Api {

  /**
   * Get server identity info (no auth required)
   * GET /identity
   */
  public async getIdentity(): Promise<PlexResponse> {
    return this.apiClient.get({ path: "/identity" })
  }

  /**
   * Get server capabilities
   * GET /
   */
  public async getServerInfo(): Promise<PlexResponse> {
    return this.apiClient.get({ path: "/" })
  }
}
