import { FnosNativeApiClient } from '../network/FnosNativeApiClient'
import {
  FnosNativeItem,
  FnosNativeItemGuidRequest,
  FnosNativePlayInfo,
  FnosNativePlayRecordRequest
} from '../model/FnosNativeModels'

export class FnosNativeUserDataApi {

  readonly apiClient: FnosNativeApiClient

  constructor(apiClient: FnosNativeApiClient) {
    this.apiClient = apiClient
  }

  public async setFavorite(guid: string, favorite: boolean): Promise<void> {
    let body: FnosNativeItemGuidRequest = { item_guid: guid }
    await this.apiClient.call<void>(favorite ? 'PUT' : 'DELETE', '/item/favorite', undefined, body)
  }

  public async setWatched(guid: string, watched: boolean): Promise<void> {
    let body: FnosNativeItemGuidRequest = { item_guid: guid }
    await this.apiClient.call<void>(watched ? 'POST' : 'DELETE', '/item/watched', undefined, body)
  }

  public async getPlayList(): Promise<FnosNativeItem[]> {
    let list = await this.apiClient.call<FnosNativeItem[]>('GET', '/play/list')
    return list ? list : []
  }

  public async getPlayInfo(itemGuid: string): Promise<FnosNativePlayInfo> {
    let body: FnosNativeItemGuidRequest = { item_guid: itemGuid }
    return this.apiClient.call<FnosNativePlayInfo>('POST', '/play/info', undefined, body)
  }

  public async reportRecord(request: FnosNativePlayRecordRequest): Promise<void> {
    await this.apiClient.call<void>('POST', '/play/record', undefined, request)
  }
}
