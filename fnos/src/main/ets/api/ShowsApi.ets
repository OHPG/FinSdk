import { Api } from "./Api";
import { FnosItemsResult } from "../model/FnosBaseItem";

export class ShowsApi extends Api {

  /** GET /Shows/{seriesId}/Seasons */
  public async getSeasons(seriesId: string): Promise<FnosItemsResult> {
    this.assertParam(seriesId)
    return this.apiClient.get({
      path: `/Shows/${encodeURIComponent(seriesId)}/Seasons`,
      parameters: this.userParams()
    })
  }

  /** GET /Shows/{seriesId}/Episodes?seasonId= */
  public async getEpisodes(seriesId: string, seasonId?: string): Promise<FnosItemsResult> {
    this.assertParam(seriesId)
    let params = this.userParams()
    if (seasonId) {
      params['seasonId'] = seasonId
    }
    return this.apiClient.get({
      path: `/Shows/${encodeURIComponent(seriesId)}/Episodes`,
      parameters: params
    })
  }
}
