import { Api } from "./Api";
import { FnosBaseItem, FnosItemsResult } from "../model/FnosBaseItem";
import { FnosLibrary } from "../model/FnosLibrary";
import { FnosLibraryType } from "../model/FnosEnums";

export interface FnosItemsRequest {
  readonly parentId?: string
  readonly recursive?: boolean
  readonly startIndex?: number
  readonly limit?: number
  readonly searchTerm?: string
  /** 逗号分隔，如 "Movie,Series"。服务端是否支持未验证。 */
  readonly includeItemTypes?: string
}

export class ItemsApi extends Api {

  /** GET /UserViews */
  public async getUserViews(): Promise<FnosItemsResult> {
    return this.apiClient.get({ path: "/UserViews", parameters: this.userParams() })
  }

  /**
   * 媒体库列表：取每个视图的第一条 Item，Type 为 Series 视为剧集库，Movie 视为电影库，
   * 其余（音乐、空库等）过滤掉。N 个库会发 N+1 次请求。
   */
  public async getLibraries(): Promise<FnosLibrary[]> {
    let views = await this.getUserViews()
    let libraries: FnosLibrary[] = []
    for (const view of views.Items ?? []) {
      if (!view.Id) {
        continue
      }
      let first = await this.getItems({ parentId: view.Id, limit: 1 })
      let type = first.Items?.[0]?.Type
      if (type === 'Series') {
        libraries.push({ id: view.Id, name: view.Name ?? '', type: FnosLibraryType.TvShow })
      } else if (type === 'Movie') {
        libraries.push({ id: view.Id, name: view.Name ?? '', type: FnosLibraryType.Movie })
      }
    }
    return libraries
  }

  /** GET /Items（浏览 / 分页 / 搜索）。 */
  public async getItems(request: FnosItemsRequest): Promise<FnosItemsResult> {
    let params = this.userParams()
    if (request.parentId) {
      params['parentId'] = request.parentId
    }
    if (request.recursive !== undefined) {
      params['recursive'] = request.recursive ? 'true' : 'false'
    }
    if (request.startIndex !== undefined) {
      params['startIndex'] = String(request.startIndex)
    }
    if (request.limit !== undefined) {
      params['limit'] = String(request.limit)
    }
    if (request.searchTerm) {
      params['searchTerm'] = request.searchTerm
    }
    if (request.includeItemTypes) {
      params['includeItemTypes'] = request.includeItemTypes
    }
    return this.apiClient.get({ path: "/Items", parameters: params })
  }

  /** GET /Items?searchTerm=。 */
  public async search(searchTerm: string, limit?: number): Promise<FnosItemsResult> {
    return this.getItems({ searchTerm: searchTerm, recursive: true, limit: limit })
  }

  /** GET /Items/{id}（详情，含 MediaSources / People 等）。 */
  public async getItem(itemId: string): Promise<FnosBaseItem> {
    this.assertParam(itemId)
    return this.apiClient.get({ path: `/Items/${encodeURIComponent(itemId)}`, parameters: this.userParams() })
  }
}
