import { Api } from "./Api";
import { BaseItemDtoQueryResult } from "../model/BaseItemDtoQueryResult";

export interface UserViewsApiGetUserViewsRequest {
  readonly userId?: string
  readonly includeExternalContent?: boolean
  readonly includeHidden?: boolean
}

export class UserViewsApi extends Api {

  public getUserViews(requestParameters: UserViewsApiGetUserViewsRequest = {}): Promise<BaseItemDtoQueryResult> {
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Views`,
      parameters: requestParameters
    })
  }
}
