import { ApiClient, ClientInfo } from "@ohpg/network";
import { DeviceInfo } from "@ohpg/network";
import { SystemApi } from "./api/SystemApi";
import { UserApi } from "./api/UserApi";
import { ItemsApi } from "./api/ItemsApi";
import { UserLibraryApi } from "./api/UserLibraryApi";
import { UserViewsApi } from "./api/UserViewsApi";
import { TvShowsApi } from "./api/TvShowsApi";
import { MediaInfoApi } from "./api/MediaInfoApi";
import { VideosApi } from "./api/VideosApi";
import { PlayStateApi } from "./api/PlayStateApi";
import { EmbyApiClient } from "./network/EmbyApiClient";
import { ServerInfo, UserInfo } from "@ohpg/network";

/**
 * @Author peerless2012
 * @Email peerless2012@126.com
 * @DateTime 2025/7/5 21:07
 * @Version V1.0
 * @Description Emby
 */
export class Emby {

  readonly clientInfo: ClientInfo;

  readonly deviceInfo: DeviceInfo;

  readonly apiClient: ApiClient

  private systemApi?: SystemApi
  private userApi?: UserApi
  private itemsApi?: ItemsApi
  private userLibraryApi?: UserLibraryApi
  private userViewsApi?: UserViewsApi
  private tvShowsApi?: TvShowsApi
  private mediaInfoApi?: MediaInfoApi
  private videosApi?: VideosApi
  private playStateApi?: PlayStateApi

  constructor(clientInfo: ClientInfo, deviceInfo: DeviceInfo) {
    this.deviceInfo = deviceInfo
    this.clientInfo = clientInfo
    this.apiClient = new EmbyApiClient(clientInfo, deviceInfo)
  }

  public selectServer(serverInfo: ServerInfo) {
    this.apiClient.updateServer(serverInfo)
  }

  public selectUser(userInfo: UserInfo) {
    (this.apiClient as EmbyApiClient).updateUserInfo(userInfo)
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

  public getUserLibraryApi(): UserLibraryApi {
    if (!this.userLibraryApi) {
      this.userLibraryApi = new UserLibraryApi(this.apiClient)
    }
    return this.userLibraryApi
  }

  public getUserViewsApi(): UserViewsApi {
    if (!this.userViewsApi) {
      this.userViewsApi = new UserViewsApi(this.apiClient)
    }
    return this.userViewsApi
  }

  public getTvShowsApi(): TvShowsApi {
    if (!this.tvShowsApi) {
      this.tvShowsApi = new TvShowsApi(this.apiClient)
    }
    return this.tvShowsApi
  }

  public getMediaInfoApi(): MediaInfoApi {
    if (!this.mediaInfoApi) {
      this.mediaInfoApi = new MediaInfoApi(this.apiClient)
    }
    return this.mediaInfoApi
  }

  public getVideosApi(): VideosApi {
    if (!this.videosApi) {
      this.videosApi = new VideosApi(this.apiClient)
    }
    return this.videosApi
  }

  public getPlayStateApi(): PlayStateApi {
    if (!this.playStateApi) {
      this.playStateApi = new PlayStateApi(this.apiClient)
    }
    return this.playStateApi
  }
}
