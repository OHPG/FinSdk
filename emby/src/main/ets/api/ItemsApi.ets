import { Api } from "./Api";
import { BaseItemKind } from "../model/BaseItemKind";
import { ItemFields } from "../model/ItemFields";
import { ItemFilter } from "../model/ItemFilter";
import { ItemSortBy } from "../model/ItemSortBy";
import { SortOrder } from "../model/SortOrder";
import { UserItemDataDto } from "../model/UserItemDataDto";
import { BaseItemDtoQueryResult } from "../model/BaseItemDtoQueryResult";

export interface ItemsApiGetItemUserDataRequest {
  readonly itemId: string
  readonly userId?: string
}

export interface ItemsApiGetItemsRequest {
  readonly userId?: string
  readonly startIndex?: number
  readonly limit?: number
  readonly recursive?: boolean
  readonly searchTerm?: string
  readonly sortOrder?: Array<SortOrder>
  readonly parentId?: string
  readonly fields?: Array<ItemFields>
  readonly excludeItemTypes?: Array<BaseItemKind>
  readonly includeItemTypes?: Array<BaseItemKind>
  readonly filters?: Array<ItemFilter>
  readonly isFavorite?: boolean
  readonly sortBy?: Array<ItemSortBy>
  readonly isPlayed?: boolean
  readonly enableUserData?: boolean
  readonly enableImages?: boolean
  readonly enableTotalRecordCount?: boolean
}

export interface ItemsApiGetResumeItemsRequest {
  readonly userId?: string
  readonly startIndex?: number
  readonly limit?: number
  readonly parentId?: string
  readonly fields?: Array<ItemFields>
  readonly includeItemTypes?: Array<BaseItemKind>
  readonly enableUserData?: boolean
  readonly enableImages?: boolean
  readonly enableTotalRecordCount?: boolean
}

export class ItemsApi extends Api {

  public async getItemUserData(requestParameters: ItemsApiGetItemUserDataRequest): Promise<UserItemDataDto> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Items/${requestParameters.itemId}/UserData`,
      parameters: requestParameters
    })
  }

  public async getItems(requestParameters: ItemsApiGetItemsRequest = {}): Promise<BaseItemDtoQueryResult> {
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Items`,
      parameters: requestParameters
    })
  }

  public async getResumeItems(requestParameters: ItemsApiGetResumeItemsRequest = {}): Promise<BaseItemDtoQueryResult> {
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Items/Resume`,
      parameters: requestParameters
    })
  }
}
