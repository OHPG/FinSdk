import { FnosNativeApiClient } from '../network/FnosNativeApiClient'
import { FnosNativeStreamListData } from '../model/FnosNativeModels'

const IMG_PREFIX = '/v/api/v1/sys/img'

export class FnosNativePlaybackApi {

  readonly apiClient: FnosNativeApiClient

  constructor(apiClient: FnosNativeApiClient) {
    this.apiClient = apiClient
  }

  public async getStreamList(itemGuid: string): Promise<FnosNativeStreamListData> {
    return this.apiClient.call<FnosNativeStreamListData>('GET', `/stream/list/${itemGuid}`)
  }

  /** 原画直连地址，播放需带 getMediaHeaders()。 */
  public getDirectUrl(mediaGuid: string): string {
    return `${this.apiClient.getBase()}/v/api/v1/media/range/${mediaGuid}`
  }

  /** 图片地址：兼容已含前缀的路径与 http(s) 绝对地址；图片请求需带 getMediaHeaders()。 */
  public getImageUrl(path: string, width?: number): string {
    if (!path) {
      return ''
    }
    let url: string
    if (path.startsWith('http://') || path.startsWith('https://')) {
      url = path
    } else if (path.startsWith(IMG_PREFIX)) {
      url = `${this.apiClient.getBase()}${path}`
    } else {
      url = `${this.apiClient.getBase()}${IMG_PREFIX}${path.startsWith('/') ? path : '/' + path}`
    }
    if (width !== undefined && width > 0) {
      url += (url.indexOf('?') >= 0 ? '&' : '?') + `w=${width}`
    }
    return url
  }
}
