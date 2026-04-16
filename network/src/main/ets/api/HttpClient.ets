import { Axios, AxiosRequestConfig, AxiosResponse, ParamsSerializerOptions } from "@ohos/axios"
import { rcp } from '@kit.RemoteCommunicationKit';
import { ApiError } from "./ApiError";
import { ApiRequest } from "./ApiRequest";

/** The authorization header field name. */
export const HEADER_ACCEPT = 'application/json, application/octet-stream;q=0.9, */*;q=0.8';

export const JSON_TYPE = 'application/json'

export const FORM_TYPE = 'application/x-www-form-urlencoded'

/**
 * 通用 HTTP 客户端，提供连接复用的 GET/POST/PUT/PATCH/DELETE 能力。
 * 不绑定任何业务概念（如 Server / Auth），子类按需覆写 getHeaders。
 */
export class HttpClient {

  private axios?: Axios

  private rcpSession?: rcp.Session

  constructor(baseUrl?: string) {
    if (baseUrl) {
      this.initClient(baseUrl)
    }
  }

  private initClient(baseUrl: string): void {
    let basePath = baseUrl.endsWith('/')
      ? baseUrl.slice(0, -1)
      : baseUrl;
    this.axios = new Axios({
      baseURL: basePath,
      paramsSerializer: {
        serialize: this.paramsSerializer
      }
    })
    this.rcpSession?.close()
    this.rcpSession = rcp.createSession({
      baseAddress: basePath
    })
  }

  /**
   * 运行时更新 baseURL，重建内部连接。
   */
  protected updateBaseUrl(baseUrl: string): void {
    this.initClient(baseUrl)
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

  protected getHeaders(request: ApiRequest): Record<string, string> {
    return {
      'Accept': HEADER_ACCEPT
    }
  }

  private async request<T>(request: ApiRequest, method: string): Promise<T> {
    if (this.axios == undefined) {
      throw new ApiError(403, "Server not set.") as Error
    }

    let config: AxiosRequestConfig = {
      url: request.path,
      baseURL: request.url,
      method: method,
      headers: this.getHeaders(request),
      params: request.parameters,
      data: request.data
    }
    return this.axios
      .request<T>(config)
      .then((response: AxiosResponse) => {
        if (response.status === 204) {
          return undefined as T
        } else if (response.status == 200 || response.status == 201) {
          return JSON.parse(response.data as string) as T
        } else {
          throw new ApiError(response.status, response.data) as Error
        }
      })
  }

  private async rcpRequest<T>(request: ApiRequest, method: string): Promise<T> {
    if (this.rcpSession == undefined) {
      throw new ApiError(403, "Server not set.") as Error
    }
    let rcpRequest: rcp.Request = new rcp.Request(
      request.path, method, this.getHeaders(request), request.data
    )
    return this.rcpSession
      .fetch(rcpRequest)
      .then((response: rcp.Response) => {
        if (response.statusCode === 204) {
          return undefined as T
        } else if (response.statusCode == 200) {
          return response.toJSON() as T
        } else {
          throw new ApiError(response.statusCode, response.toString() || "") as Error
        }
      })
  }

  public async post<T>(request: ApiRequest): Promise<T> {
    return this.request(request, "POST")
  }

  public async patch<T>(request: ApiRequest): Promise<T> {
    return this.rcpRequest(request, "PATCH")
  }

  public async put<T>(request: ApiRequest): Promise<T> {
    return this.rcpRequest(request, "PUT")
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
      params: request.parameters
    }
    return this.axios.getUri(config)
  }

  public release() {
    this.rcpSession?.close()
    this.rcpSession = undefined
  }

}
