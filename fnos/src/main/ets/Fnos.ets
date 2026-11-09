import { ClientInfo, DeviceInfo, ServerInfo, UserInfo } from "@ohpg/network";
import { FnosApiClient } from "./network/FnosApiClient";
import { SystemApi } from "./api/SystemApi";
import { UserApi } from "./api/UserApi";
import { ItemsApi } from "./api/ItemsApi";
import { ShowsApi } from "./api/ShowsApi";
import { PlaybackApi } from "./api/PlaybackApi";
import { UserDataApi } from "./api/UserDataApi";

/**
 * 飞牛影视（fnOS）兼容模式入口：走飞牛提供的部分 Jellyfin 兼容接口，直连 + 原画播放。
 * 接口事实来自开源客户端 Lumy Player，未经真实服务器验证。
 */
export class Fnos {

  readonly clientInfo: ClientInfo;

  readonly deviceInfo: DeviceInfo;

  readonly apiClient: FnosApiClient

  private systemApi?: SystemApi
  private userApi?: UserApi
  private itemsApi?: ItemsApi
  private showsApi?: ShowsApi
  private playbackApi?: PlaybackApi
  private userDataApi?: UserDataApi

  constructor(clientInfo: ClientInfo, deviceInfo: DeviceInfo) {
    this.clientInfo = clientInfo
    this.deviceInfo = deviceInfo
    this.apiClient = new FnosApiClient(clientInfo, deviceInfo)
  }

  public selectServer(serverInfo: ServerInfo) {
    this.apiClient.updateServer(serverInfo)
  }

  public selectUser(userInfo: UserInfo) {
    this.apiClient.updateUserInfo(userInfo)
  }

  public getSystemApi(): SystemApi {
    if (!this.systemApi) {
      this.systemApi = new SystemApi(this.apiClient)
    }
    return this.systemApi
  }

  public getUserApi(): UserApi {
    if (!this.userApi) {
      this.userApi = new UserApi(this.apiClient)
    }
    return this.userApi
  }

  public getItemsApi(): ItemsApi {
    if (!this.itemsApi) {
      this.itemsApi = new ItemsApi(this.apiClient)
    }
    return this.itemsApi
  }

  public getShowsApi(): ShowsApi {
    if (!this.showsApi) {
      this.showsApi = new ShowsApi(this.apiClient)
    }
    return this.showsApi
  }

  public getPlaybackApi(): PlaybackApi {
    if (!this.playbackApi) {
      this.playbackApi = new PlaybackApi(this.apiClient)
    }
    return this.playbackApi
  }

  public getUserDataApi(): UserDataApi {
    if (!this.userDataApi) {
      this.userDataApi = new UserDataApi(this.apiClient)
    }
    return this.userDataApi
  }
}
