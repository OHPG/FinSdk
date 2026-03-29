import { ClientInfo, ServerInfo, UserInfo } from "@ohpg/network";
import { DeviceInfo } from "@ohpg/network";
import { SystemApi } from "./api/SystemApi";
import { LibraryApi } from "./api/LibraryApi";
import { PlayStateApi } from "./api/PlayStateApi";
import { UserApi } from "./api/UserApi";
import { PlexApiClient } from "./network/PlexApiClient";

export class Plex {

  readonly clientInfo: ClientInfo;
  readonly deviceInfo: DeviceInfo;
  readonly apiClient: PlexApiClient

  private systemApi?: SystemApi
  private libraryApi?: LibraryApi
  private playStateApi?: PlayStateApi
  private userApi?: UserApi

  constructor(clientInfo: ClientInfo, deviceInfo: DeviceInfo) {
    this.clientInfo = clientInfo
    this.deviceInfo = deviceInfo
    this.apiClient = new PlexApiClient(clientInfo, deviceInfo)
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

  public getLibraryApi(): LibraryApi {
    if (!this.libraryApi) {
      this.libraryApi = new LibraryApi(this.apiClient)
    }
    return this.libraryApi
  }

  public getPlayStateApi(): PlayStateApi {
    if (!this.playStateApi) {
      this.playStateApi = new PlayStateApi(this.apiClient)
    }
    return this.playStateApi
  }

  public getUserApi(): UserApi {
    if (!this.userApi) {
      this.userApi = new UserApi(this.apiClient)
    }
    return this.userApi
  }
}
