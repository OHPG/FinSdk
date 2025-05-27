import { Axios, AxiosRequestConfig, AxiosResponse, ParamsSerializerOptions } from "@ohos/axios"
import { ClientInfo } from "../model/ClientInfo";
import { DeviceInfo } from "../model/DeviceInfo";
import { ServerInfo } from "../model/ServerInfo";
import { UserInfo } from "../model/UserInfo";
import { ApiError } from "./ApiError";
import { ApiRequest } from "./ApiRequest";

/** The authorization header field name. */
export const HEADER_ACCEPT = 'application/json, application/octet-stream;q=0.9, */*;q=0.8';

export const JSON_TYPE = 'application/json'

export const FORM_TYPE = 'application/x-www-form-urlencoded'

/**
 * @Author peerless2012
 * @Email peerless2012@126.com
 * @DateTime 2024/10/15 20:48
 * @Version V1.0
 * @Description
 */
export class ApiClient {

  readonly clientInfo: ClientInfo;

  readonly deviceInfo: DeviceInfo;

  private userInfo?: UserInfo

  private serverInfo?: ServerInfo

  private axios?: Axios

  constructor(clientInfo: ClientInfo, deviceInfo: DeviceInfo) {
    this.clientInfo = clientInfo
    this.deviceInfo = deviceInfo
  }

  private paramsSerializer(params: Record<string, ESObject>, options?: ParamsSerializerOptions): string {
    const queryString = Object.keys(params)
      .map(key => {
        const value: ESObject = params[key];
        if (Array.isArray(value)) {
          let array = new Array<string>()
          value.forEach((v: ESObject) => {
            if (v !== undefined && v !== null) {
              array.push(`${encodeURIComponent(key)}=${encodeURIComponent(v)}`)
            }
          })
          return array.join('&')
        }
        if (value === undefined || value === null) {
          return ""
        }
        return `${encodeURIComponent(key)}=${encodeURIComponent(value)}`;
      })
      .filter(Boolean)
      .join('&');

    return queryString;
  }

  public updateServerInfo(serverInfo: ServerInfo) {
    this.serverInfo = serverInfo
    let basePath = serverInfo.address.endsWith('/')
      ? serverInfo.address.slice(0, -1)
      : serverInfo.address;
    this.axios = new Axios({
      baseURL: basePath,
      paramsSerializer: {
        serialize: this.paramsSerializer
      }
    })
  }

  public getServerInfo(): ServerInfo | undefined {
    return this.serverInfo
  }

  public updateUserInfo(userInfo: UserInfo) {
    this.userInfo = userInfo
  }

  private getSafeToken(): string {
    if (this.userInfo && this.userInfo.token) {
      return this.userInfo.token
    }
    return ""
  }

  /**
   * Returns a valid authorization header string.
   */
  public getAuthorizationHeader(): string {
    return [
      `MediaBrowser Client="${encodeURIComponent(this.clientInfo.name)}"`,
      `Device="${encodeURIComponent(this.deviceInfo.name)}"`,
      `DeviceId="${encodeURIComponent(this.deviceInfo.id)}"`,
      `Version="${encodeURIComponent(this.clientInfo.version)}"`,
      `Token="${encodeURIComponent(this.getSafeToken())}"`
    ].join(', ');
  }

  private async request<T>(request: ApiRequest, method: string): Promise<T> {
    if (this.axios == undefined) {
      throw new ApiError(403, "Server not set.") as Error
    }

    let config: AxiosRequestConfig = {
      url: request.path,
      method: method,
      headers: {
        'Content-Type': JSON_TYPE,
        'Accept': HEADER_ACCEPT,
        'Authorization': this.getAuthorizationHeader()
      },
      params: request.parameters,
      data: request.data
    }
    return this.axios
      .request<T>(config)
      .then((response: AxiosResponse) => {
        if (response.status === 204) {
          return undefined as T
        } else if (response.status == 200) {
          return JSON.parse(response.data as string) as T
        } else {
          throw new ApiError(response.status, response.data) as Error
        }
      })
  }

  public async post<T>(request: ApiRequest): Promise<T> {
    return this.request(request, "POST")
  }

  public async get<T>(request: ApiRequest): Promise<T> {
    return this.request(request, "GET")
  }

  public async delete<T>(request: ApiRequest): Promise<T> {
    return this.request(request, "DELETE")
  }

  public async createUrl(request: ApiRequest): Promise<string> {
    if (this.axios == undefined) {
      throw new ApiError(403, "Server not set.") as Error
    }
    let config: AxiosRequestConfig = {
      url: request.path,
      method: "GET",
      headers: {
        'Content-Type': JSON_TYPE,
        'Accept': HEADER_ACCEPT,
        'Authorization': this.getAuthorizationHeader()
      },
      params: request.parameters
    }
    return this.axios.getUri(config)
  }

}