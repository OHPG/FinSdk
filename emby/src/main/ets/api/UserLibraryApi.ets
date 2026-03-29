import { Api } from "./Api";
import { ItemFields } from "../model/ItemFields";
import { BaseItemDto } from "../model/BaseItemDto";
import { BaseItemKind } from "../model/BaseItemKind";
import { UserItemDataDto } from "../model/UserItemDataDto";

export interface UserLibraryApiGetItemRequest {
  readonly itemId: string
  readonly userId?: string
}

export interface UserLibraryApiGetLatestMediaRequest {
  readonly userId?: string
  readonly parentId?: string
  readonly fields?: Array<ItemFields>
  readonly includeItemTypes?: Array<BaseItemKind>
  readonly limit?: number
  readonly groupItems?: boolean
  readonly enableImages?: boolean
  readonly enableUserData?: boolean
}

export interface UserLibraryApiMarkFavoriteItemRequest {
  readonly itemId: string
  readonly userId?: string
}

export interface UserLibraryApiUnmarkFavoriteItemRequest {
  readonly itemId: string
  readonly userId?: string
}

export class UserLibraryApi extends Api {

  public async getItem(requestParameters: UserLibraryApiGetItemRequest): Promise<BaseItemDto> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Items/${requestParameters.itemId}`,
    })
  }

  public async getLatestMedia(requestParameters: UserLibraryApiGetLatestMediaRequest = {}): Promise<Array<BaseItemDto>> {
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Items/Latest`,
      parameters: requestParameters
    })
  }

  public async markFavoriteItem(requestParameters: UserLibraryApiMarkFavoriteItemRequest): Promise<UserItemDataDto> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.post({
      path: `/Users/${requestParameters.userId}/FavoriteItems/${requestParameters.itemId}`,
    })
  }

  public async unmarkFavoriteItem(requestParameters: UserLibraryApiUnmarkFavoriteItemRequest): Promise<UserItemDataDto> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.delete({
      path: `/Users/${requestParameters.userId}/FavoriteItems/${requestParameters.itemId}`,
    })
  }
}
