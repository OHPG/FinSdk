import { Api } from "./Api"

export interface ScrobbleRequest {
  readonly identifier: string
  readonly key: string
}

export interface TimelineRequest {
  readonly ratingKey: string
  readonly key: string
  readonly state: string
  readonly time: number
  readonly duration: number
  readonly playbackTime?: number
}

export class PlayStateApi extends Api {

  public async scrobble(ratingKey: string): Promise<void> {
    this.assertParam(ratingKey)
    let req: ScrobbleRequest = {
      identifier: "com.plexapp.plugins.library",
      key: ratingKey
    }
    return this.apiClient.get({
      path: "/:/scrobble",
      parameters: req
    })
  }

  public async unscrobble(ratingKey: string): Promise<void> {
    this.assertParam(ratingKey)
    let req: ScrobbleRequest = {
      identifier: "com.plexapp.plugins.library",
      key: ratingKey
    }
    return this.apiClient.get({
      path: "/:/unscrobble",
      parameters: req
    })
  }

  public async timeline(req: TimelineRequest): Promise<void> {
    this.assertParam(req.ratingKey)
    return this.apiClient.get({
      path: "/:/timeline",
      parameters: req
    })
  }
}
