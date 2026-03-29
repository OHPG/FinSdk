import { Api } from "./Api"

export interface VideosApiGetVideoStreamRequest {
  readonly itemId: string
  readonly static?: boolean
  readonly mediaSourceId?: string
  readonly api_key?: string
}

export class VideosApi extends Api {

  public async getVideoStreamUrl(requestParameters: VideosApiGetVideoStreamRequest): Promise<string> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.createUrl({
      method: "GET",
      path: `/Videos/${requestParameters.itemId}/stream`,
      parameters: requestParameters
    })
  }
}
