import { Api } from "./Api";
import { FnosImageType } from "../model/FnosEnums";

export interface FnosImageUrlRequest {
  readonly itemId: string
  readonly type: FnosImageType
  /** Backdrop 等多图类型的序号；Lumy 对 Backdrop/0 会去掉序号 */
  readonly index?: number
  readonly tag?: string
  readonly maxWidth?: number
  readonly maxHeight?: number
}

export interface FnosStreamUrlRequest {
  readonly itemId: string
  readonly mediaSourceId: string
  readonly playSessionId: string
}

export interface FnosSubtitleUrlRequest {
  readonly itemId: string
  readonly mediaSourceId: string
  readonly index: number
  /** 字幕扩展名，如 srt / ass / vtt */
  readonly ext: string
}

/**
 * URL 构造（不发网络请求）：图片、原画直连播放、外挂字幕。
 * 播放 / 字幕 URL 以 ApiKey 查询参数携带 token；DeviceId 使用登录时同一个。
 */
export class PlaybackApi extends Api {

  /**
   * 图片 URL。是否必须携带请求头未验证；上层可用 getAuthHeaders() 作为 FinImage.header。
   */
  public getImageUrl(request: FnosImageUrlRequest): string {
    this.assertParam(request.itemId)
    let path = `/Items/${encodeURIComponent(request.itemId)}/Images/${request.type}`
    if (request.index !== undefined && request.index > 0) {
      path += `/${request.index}`
    }
    let query: string[] = []
    if (request.tag) {
      query.push(`tag=${encodeURIComponent(request.tag)}`)
    }
    if (request.maxWidth !== undefined) {
      query.push(`maxWidth=${request.maxWidth}`)
    }
    if (request.maxHeight !== undefined) {
      query.push(`maxHeight=${request.maxHeight}`)
    }
    return this.buildUrl(path, query)
  }

  /** 原画直连：/Videos/{id}/stream?Static=true&MediaSourceId&PlaySessionId&DeviceId&ApiKey */
  public getStreamUrl(request: FnosStreamUrlRequest): string {
    this.assertParam(request.itemId)
    let query: string[] = [
      'Static=true',
      `MediaSourceId=${encodeURIComponent(request.mediaSourceId)}`,
      `PlaySessionId=${encodeURIComponent(request.playSessionId)}`,
      `DeviceId=${encodeURIComponent(this.apiClient.getDeviceId())}`,
      `ApiKey=${encodeURIComponent(this.apiClient.getToken())}`
    ]
    return this.buildUrl(`/Videos/${encodeURIComponent(request.itemId)}/stream`, query)
  }

  /** 外挂字幕：/Videos/{itemId}/{sourceId}/Subtitles/{index}/Stream.{ext}?ApiKey */
  public getSubtitleUrl(request: FnosSubtitleUrlRequest): string {
    this.assertParam(request.itemId)
    let path = `/Videos/${encodeURIComponent(request.itemId)}/${encodeURIComponent(request.mediaSourceId)}` +
      `/Subtitles/${request.index}/Stream.${request.ext}`
    return this.buildUrl(path, [`ApiKey=${encodeURIComponent(this.apiClient.getToken())}`])
  }

  /** 图片 / 播放器请求头（X-Emby-Authorization + X-Emby-Token）。 */
  public getAuthHeaders(): Record<string, string> {
    return this.apiClient.getAuthHeaders()
  }

  private buildUrl(path: string, query: string[]): string {
    let url = this.getBase() + path
    return query.length > 0 ? `${url}?${query.join('&')}` : url
  }
}
