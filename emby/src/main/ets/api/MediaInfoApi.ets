import { Api } from "./Api"
import { PlaybackInfoResponse } from "../model/PlaybackInfoResponse"

export interface MediaInfoApiGetPlaybackInfoRequest {
  readonly itemId: string
  readonly userId?: string
}

export interface MediaInfoApiPostPlaybackInfoRequest {
  readonly itemId: string
  readonly userId?: string
  readonly data: PlaybackInfoRequestBody
}

export interface PlaybackInfoRequestBody {
  UserId?: string
  MediaSourceId?: string
  EnableDirectPlay?: boolean
  EnableDirectStream?: boolean
  EnableTranscoding?: boolean
  IsPlayback?: boolean
  AutoOpenLiveStream?: boolean
  DeviceProfile?: DeviceProfileBody
}

export interface DeviceProfileBody {
  MaxStreamingBitrate?: number
  DirectPlayProfiles?: Array<DirectPlayProfileBody>
  TranscodingProfiles?: Array<TranscodingProfileBody>
  SubtitleProfiles?: Array<SubtitleProfileBody>
}

export interface DirectPlayProfileBody {
  Container?: string
  AudioCodec?: string
  VideoCodec?: string
  Type?: string
}

export interface TranscodingProfileBody {
  Container?: string
  Type?: string
  VideoCodec?: string
  AudioCodec?: string
  Protocol?: string
  Context?: string
}

export interface SubtitleProfileBody {
  Format?: string
  Method?: string
}

export class MediaInfoApi extends Api {

  public async getPlaybackInfo(requestParameters: MediaInfoApiGetPlaybackInfoRequest): Promise<PlaybackInfoResponse> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.get({
      path: `/Items/${requestParameters.itemId}/PlaybackInfo`,
      parameters: requestParameters
    })
  }

  public async postPlaybackInfo(requestParameters: MediaInfoApiPostPlaybackInfoRequest): Promise<PlaybackInfoResponse> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.post({
      path: `/Items/${requestParameters.itemId}/PlaybackInfo`,
      data: requestParameters.data
    })
  }
}
