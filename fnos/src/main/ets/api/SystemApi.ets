import { Api } from "./Api";
import { FnosPublicSystemInfo } from "../model/FnosAuth";

export class SystemApi extends Api {
  /**
   * 免登录获取服务器信息（Id / ServerName / Version），可用于连通性检测。
   */
  public async getPublicInfo(): Promise<FnosPublicSystemInfo> {
    return this.apiClient.get({ path: "/System/Info/Public" })
  }
}
