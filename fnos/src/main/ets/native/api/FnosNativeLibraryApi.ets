import { FnosNativeApiClient } from '../network/FnosNativeApiClient'
import { FnosQueryPair } from '../auth/FnosAuthxSigner'
import {
  FnosNativeEmpty,
  FnosNativeGenre,
  FnosNativeGenresData,
  FnosNativeItem,
  FnosNativeItemListData,
  FnosNativeItemListRequest,
  FnosNativeMediaDb,
  FnosNativePerson,
  FnosNativePersonListData,
  FnosNativeSearchData
} from '../model/FnosNativeModels'

export class FnosNativeLibraryApi {

  readonly apiClient: FnosNativeApiClient

  constructor(apiClient: FnosNativeApiClient) {
    this.apiClient = apiClient
  }

  public async getMediaDbList(): Promise<FnosNativeMediaDb[]> {
    let list = await this.apiClient.call<FnosNativeMediaDb[]>('GET', '/mediadb/list')
    return list ? list : []
  }

  public async getItemList(request: FnosNativeItemListRequest): Promise<FnosNativeItemListData> {
    return this.apiClient.call<FnosNativeItemListData>('POST', '/item/list', undefined, request)
  }

  public async getItem(guid: string): Promise<FnosNativeItem> {
    return this.apiClient.call<FnosNativeItem>('GET', `/item/${guid}`)
  }

  public async getSeasons(seriesGuid: string): Promise<FnosNativeItem[]> {
    let list = await this.apiClient.call<FnosNativeItem[]>('GET', `/season/list/${seriesGuid}`)
    return list ? list : []
  }

  public async getEpisodes(seasonGuid: string): Promise<FnosNativeItem[]> {
    let list = await this.apiClient.call<FnosNativeItem[]>('GET', `/episode/list/${seasonGuid}`)
    return list ? list : []
  }

  public async getPersons(guid: string): Promise<FnosNativePerson[]> {
    let body: FnosNativeEmpty = {}
    let data = await this.apiClient.call<FnosNativePersonListData>('POST', `/person/list/${guid}`, undefined, body)
    return data && data.list ? data.list : []
  }

  public async search(keyword: string): Promise<FnosNativeItem[]> {
    let query: FnosQueryPair[] = [{ key: 'q', value: keyword }]
    let data = await this.apiClient.call<FnosNativeSearchData>('GET', '/search/list', query)
    return data && data.list ? data.list : []
  }

  public async getGenres(): Promise<FnosNativeGenre[]> {
    let data = await this.apiClient.call<FnosNativeGenresData>('GET', '/tag/genres')
    return data && data.genres ? data.genres : []
  }

  public async getFavoriteList(request: FnosNativeItemListRequest): Promise<FnosNativeItemListData> {
    return this.apiClient.call<FnosNativeItemListData>('POST', '/favorite/list', undefined, request)
  }
}
