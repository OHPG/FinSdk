import { ApiError } from "@ohpg/network";
import { FnosApiClient } from "../network/FnosApiClient";

export class Api {

  readonly apiClient: FnosApiClient;

  constructor(apiClient: FnosApiClient) {
    this.apiClient = apiClient
  }

  protected assertParam(param?: string | number | null) {
    if (param == undefined || param == null || param === '') {
      throw new ApiError(403, "Param error") as Error
    }
  }

  /** 浏览类请求统一带 userId（Lumy：所有浏览请求均带 userId）。 */
  protected userParams(): Record<string, string> {
    let params: Record<string, string> = {}
    params['userId'] = this.apiClient.getUserId()
    return params
  }

  /** 服务器根地址（无末尾 /）。 */
  protected getBase(): string {
    let address = this.apiClient.getServer()?.address || ""
    return address.endsWith('/') ? address.slice(0, -1) : address
  }
}
