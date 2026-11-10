import { ClientInfo, DeviceInfo, ServerInfo } from '@ohpg/network'
import { AuthxProvider } from './auth/AuthxProvider'
import { FnosNativeApiClient } from './network/FnosNativeApiClient'
import { FnosNativeUserApi } from './api/FnosNativeUserApi'
import { FnosNativeLibraryApi } from './api/FnosNativeLibraryApi'
import { FnosNativeUserDataApi } from './api/FnosNativeUserDataApi'
import { FnosNativePlaybackApi } from './api/FnosNativePlaybackApi'

/**
 * 飞牛影视原生模式入口（/v/api/v1/*，带 authx 签名）。接口事实来自开源客户端源码，未经真机验证。
 */
export class FnosNative {

  readonly apiClient: FnosNativeApiClient

  private userApi?: FnosNativeUserApi
  private libraryApi?: FnosNativeLibraryApi
  private userDataApi?: FnosNativeUserDataApi
  private playbackApi?: FnosNativePlaybackApi

  constructor(clientInfo: ClientInfo, deviceInfo: DeviceInfo, provider?: AuthxProvider) {
    this.apiClient = new FnosNativeApiClient(clientInfo, deviceInfo, provider)
  }

  public selectServer(serverInfo: ServerInfo) {
    this.apiClient.updateServer(serverInfo)
  }

  public selectToken(token: string) {
    this.apiClient.updateToken(token)
  }

  public getUserApi(): FnosNativeUserApi {
    if (!this.userApi) {
      this.userApi = new FnosNativeUserApi(this.apiClient)
    }
    return this.userApi
  }

  public getLibraryApi(): FnosNativeLibraryApi {
    if (!this.libraryApi) {
      this.libraryApi = new FnosNativeLibraryApi(this.apiClient)
    }
    return this.libraryApi
  }

  public getUserDataApi(): FnosNativeUserDataApi {
    if (!this.userDataApi) {
      this.userDataApi = new FnosNativeUserDataApi(this.apiClient)
    }
    return this.userDataApi
  }

  public getPlaybackApi(): FnosNativePlaybackApi {
    if (!this.playbackApi) {
      this.playbackApi = new FnosNativePlaybackApi(this.apiClient)
    }
    return this.playbackApi
  }
}
