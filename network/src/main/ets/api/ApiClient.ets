import { ClientInfo } from "../entity/ClientInfo";
import { DeviceInfo } from "../entity/DeviceInfo";
import { ServerInfo } from "../entity/ServerInfo";
import { ApiRequest } from "./ApiRequest";
import { HttpClient, HEADER_ACCEPT, JSON_TYPE } from "./HttpClient";

// 保持向后兼容的重导出
export { HEADER_ACCEPT, JSON_TYPE, FORM_TYPE } from "./HttpClient";

/**
 * @Author peerless2012
 * @Email peerless2012@126.com
 * @DateTime 2024/10/15 20:48
 * @Version V1.0
 * @Description 媒体服务器 API 客户端基类，绑定 ClientInfo / DeviceInfo / ServerInfo。
 */
export abstract class ApiClient extends HttpClient {

  public readonly clientInfo: ClientInfo;

  public readonly deviceInfo: DeviceInfo;

  private serverInfo?: ServerInfo

  constructor(clientInfo: ClientInfo, deviceInfo: DeviceInfo) {
    super()
    this.clientInfo = clientInfo
    this.deviceInfo = deviceInfo
  }

  /**
   * Update server address
   * @param serverInfo
   */
  public updateServer(serverInfo: ServerInfo) {
    this.serverInfo = serverInfo
    let basePath = serverInfo.address.endsWith('/')
      ? serverInfo.address.slice(0, -1)
      : serverInfo.address;
    this.updateBaseUrl(basePath)
  }

  public getServer(): ServerInfo | undefined {
    return this.serverInfo
  }

  /**
   * Returns a valid authorization header string.
   */
  public abstract getAuthorization(): string

  protected getHeaders(request: ApiRequest): Record<string, string> {
    return {
      'Content-Type': JSON_TYPE,
      'Accept': HEADER_ACCEPT,
      'Authorization': this.getAuthorization(),
      'User-Agent': `${this.clientInfo.name}/${this.clientInfo.version} (HarmonyOS)`
    }
  }

}
