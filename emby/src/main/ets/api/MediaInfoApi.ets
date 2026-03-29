import { Api } from "./Api"
import { PlaybackInfoResponse } from "../model/PlaybackInfoResponse"

export interface MediaInfoApiGetPlaybackInfoRequest {
  readonly itemId: string
  readonly userId?: string
}

export class MediaInfoApi extends Api {

  public async getPlaybackInfo(requestParameters: MediaInfoApiGetPlaybackInfoRequest): Promise<PlaybackInfoResponse> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.get({
      path: `/Items/${requestParameters.itemId}/PlaybackInfo`,
      parameters: requestParameters
    })
  }
}
