import { Api } from "./Api";
import { BaseItemDto } from "../model/BaseItemDto";
import { BaseItemDtoQueryResult } from "../model/BaseItemDtoQueryResult";
import { ItemFields } from "../model/ItemFields";
import { BaseItemKind } from "../model/BaseItemKind";
import { ItemSortBy } from "../model/ItemSortBy";
import { SortOrder } from "../model/SortOrder";

/**
 * Request parameters for getUserItem operation in UsersApi.
 * @export
 * @interface UsersApiGetItemRequest
 */
export interface UsersApiGetItemRequest {
  /**
   * The user id.
   * @type {string}
   * @memberof UsersApiGetItem
   */
  readonly userId: string

  /**
   * The item id.
   * @type {string}
   * @memberof UsersApiGetItem
   */
  readonly itemId: string
}

/**
 * Request parameters for getUserItems operation in UsersApi.
 * @export
 * @interface UsersApiGetItemsRequest
 */
export interface UsersApiGetItemsRequest {
  /**
   * The user id.
   * @type {string}
   * @memberof UsersApiGetItems
   */
  readonly userId: string

  /**
   * Optional. If specified, results will be filtered based on the item type.
   * @type {Array<BaseItemKind>}
   * @memberof UsersApiGetItems
   */
  readonly includeItemTypes?: Array<BaseItemKind>

  /**
   * Optional. Specify additional fields of information to return in the output.
   * @type {Array<ItemFields>}
   * @memberof UsersApiGetItems
   */
  readonly fields?: Array<ItemFields>

  /**
   * Optional. If true, search recursively.
   * @type {boolean}
   * @memberof UsersApiGetItems
   */
  readonly recursive?: boolean

  /**
   * Optional. Specify one or more sort orders, comma delimited.
   * @type {Array<ItemSortBy>}
   * @memberof UsersApiGetItems
   */
  readonly sortBy?: Array<ItemSortBy>

  /**
   * Sort order.
   * @type {Array<SortOrder>}
   * @memberof UsersApiGetItems
   */
  readonly sortOrder?: Array<SortOrder>

  /**
   * Optional. The record index to start at.
   * @type {number}
   * @memberof UsersApiGetItems
   */
  readonly startIndex?: number

  /**
   * Optional. The maximum number of records to return.
   * @type {number}
   * @memberof UsersApiGetItems
   */
  readonly limit?: number

  /**
   * Optional. Specify its parent id to search within a specific folder.
   * @type {string}
   * @memberof UsersApiGetItems
   */
  readonly parentId?: string
}

/**
 * UsersApi - object-oriented interface
 *
 * 封装 /Users/{userId}/Items/... 系列接口。
 * 与 UserLibraryApi（/Items/{id}?userId=...）的区别在于：
 * 这里的路径把 userId 放在 URL 中，Jellyfin 服务端会据此填充完整的 UserData
 * （含 PlaybackPositionTicks），是获取单条 Item 带播放进度的可靠方式。
 *
 * @export
 * @class UsersApi
 * @extends {Api}
 */
export class UsersApi extends Api {

  /**
   * getUserItem
   * @summary Gets an item from a user's library. Walks GET /Users/{userId}/Items/{itemId}.
   *          The server fills in UserData (including PlaybackPositionTicks) based on userId.
   * @param {UsersApiGetItemRequest} requestParameters Request parameters.
   * @throws {RequiredError}
   * @memberof UsersApi
   */
  public async getUserItem(requestParameters: UsersApiGetItemRequest): Promise<BaseItemDto> {
    this.assertParam(requestParameters.userId)
    this.assertParam(requestParameters.itemId)
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Items/${requestParameters.itemId}`
    })
  }

  /**
   * getUserItems
   * @summary Gets items from a user's library. Walks GET /Users/{userId}/Items.
   * @param {UsersApiGetItemsRequest} requestParameters Request parameters.
   * @throws {RequiredError}
   * @memberof UsersApi
   */
  public async getUserItems(requestParameters: UsersApiGetItemsRequest): Promise<BaseItemDtoQueryResult> {
    this.assertParam(requestParameters.userId)
    return this.apiClient.get({
      path: `/Users/${requestParameters.userId}/Items`,
      parameters: requestParameters,
      excludeParams: ['userId']
    })
  }
}
