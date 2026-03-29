import { BaseItemDtoQueryResult } from "../model/BaseItemDtoQueryResult"
import { ItemFields } from "../model/ItemFields"
import { Api } from "./Api"

export interface TvShowsApiGetEpisodesRequest {
  readonly seriesId: string
  readonly userId?: string
  readonly fields?: Array<ItemFields>
  readonly seasonId?: string
  readonly startIndex?: number
  readonly limit?: number
  readonly enableUserData?: boolean
  readonly enableImages?: boolean
}

export interface TvShowsApiGetNextUpRequest {
  readonly userId?: string
  readonly startIndex?: number
  readonly limit?: number
  readonly fields?: Array<ItemFields>
  readonly seriesId?: string
  readonly parentId?: string
  readonly enableImages?: boolean
  readonly enableUserData?: boolean
  readonly enableTotalRecordCount?: boolean
  readonly enableResumable?: boolean
}

export interface TvShowsApiGetSeasonsRequest {
  readonly seriesId: string
  readonly userId?: string
  readonly fields?: Array<ItemFields>
  readonly enableImages?: boolean
  readonly enableUserData?: boolean
}

export class TvShowsApi extends Api {

  public async getEpisodes(requestParameters: TvShowsApiGetEpisodesRequest): Promise<BaseItemDtoQueryResult> {
    this.assertParam(requestParameters.seriesId)
    return this.apiClient.get({
      path: `/Shows/${requestParameters.seriesId}/Episodes`,
      parameters: requestParameters
    })
  }

  public async getNextUp(requestParameters: TvShowsApiGetNextUpRequest = {}): Promise<BaseItemDtoQueryResult> {
    return this.apiClient.get({
      path: "/Shows/NextUp",
      parameters: requestParameters
    })
  }

  public async getSeasons(requestParameters: TvShowsApiGetSeasonsRequest): Promise<BaseItemDtoQueryResult> {
    this.assertParam(requestParameters.seriesId)
    return this.apiClient.get({
      path: `/Shows/${requestParameters.seriesId}/Seasons`,
      parameters: requestParameters
    })
  }
}
