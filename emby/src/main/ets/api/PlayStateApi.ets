import { Api } from "./Api"
import { UserItemDataDto } from "../model/UserItemDataDto"
import { PlaybackStartInfo } from "../model/PlaybackStartInfo"
import { PlaybackProgressInfo } from "../model/PlaybackProgressInfo"
import { PlaybackStopInfo } from "../model/PlaybackStopInfo"

export interface PlayStateApiMarkPlayedItemRequest {
  readonly itemId: string
  readonly userId: string
}

export interface PlayStateApiMarkUnplayedItemRequest {
  readonly itemId: string
  readonly userId: string
}

export interface PlayStateApiOnPlaybackStartRequest {
  readonly itemId: string
  readonly mediaSourceId: string
  readonly playSessionId: string
  readonly canSeek?: boolean
}

export interface PlayStateApiOnPlaybackProgressRequest {
  readonly itemId: string
  readonly mediaSourceId: string
  readonly playSessionId: string
  readonly positionTicks?: number
  readonly isPaused?: boolean
}

export interface PlayStateApiOnPlaybackStoppedRequest {
  readonly itemId: string
  readonly mediaSourceId: string
  readonly playSessionId: string
  readonly positionTicks?: number
}

export class PlayStateApi extends Api {

  public async markPlayedItem(requestParameters: PlayStateApiMarkPlayedItemRequest): Promise<UserItemDataDto> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.post({
      path: `/Users/${requestParameters.userId}/PlayedItems/${requestParameters.itemId}`,
    })
  }

  public async markUnplayedItem(requestParameters: PlayStateApiMarkUnplayedItemRequest): Promise<UserItemDataDto> {
    this.assertParam(requestParameters.itemId)
    return this.apiClient.delete({
      path: `/Users/${requestParameters.userId}/PlayedItems/${requestParameters.itemId}`,
    })
  }

  public async onPlaybackStart(requestParameters: PlayStateApiOnPlaybackStartRequest): Promise<void> {
    this.assertParam(requestParameters.itemId)
    let info: PlaybackStartInfo = {
      ItemId: requestParameters.itemId,
      MediaSourceId: requestParameters.mediaSourceId,
      PlaySessionId: requestParameters.playSessionId,
      CanSeek: requestParameters.canSeek ?? true
    }
    return this.apiClient.post({
      path: `/Sessions/Playing`,
      data: info
    })
  }

  public async onPlaybackProgress(requestParameters: PlayStateApiOnPlaybackProgressRequest): Promise<void> {
    this.assertParam(requestParameters.itemId)
    let info: PlaybackProgressInfo = {
      ItemId: requestParameters.itemId,
      MediaSourceId: requestParameters.mediaSourceId,
      PlaySessionId: requestParameters.playSessionId,
      PositionTicks: requestParameters.positionTicks,
      IsPaused: requestParameters.isPaused
    }
    return this.apiClient.post({
      path: `/Sessions/Playing/Progress`,
      data: info
    })
  }

  public async onPlaybackStopped(requestParameters: PlayStateApiOnPlaybackStoppedRequest): Promise<void> {
    this.assertParam(requestParameters.itemId)
    let info: PlaybackStopInfo = {
      ItemId: requestParameters.itemId,
      MediaSourceId: requestParameters.mediaSourceId,
      PlaySessionId: requestParameters.playSessionId,
      PositionTicks: requestParameters.positionTicks
    }
    return this.apiClient.post({
      path: `/Sessions/Playing/Stopped`,
      data: info
    })
  }
}
