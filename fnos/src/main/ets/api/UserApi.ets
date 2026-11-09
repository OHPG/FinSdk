import { Api } from "./Api";
import { FnosAuthenticateRequest, FnosAuthenticationResult } from "../model/FnosAuth";

export class UserApi extends Api {
  /**
   * 用户名密码登录。请求体字段 Username / Pw 未经真实服务器验证（见 sdk-notes）。
   * 返回 AccessToken、User.Id、ServerId；调用方需用 Fnos.selectUser 写入 token。
   */
  public async authenticateByName(username: string, password: string): Promise<FnosAuthenticationResult> {
    let body: FnosAuthenticateRequest = { 'Username': username, 'Pw': password }
    return this.apiClient.post({ path: "/Users/AuthenticateByName", data: body })
  }
}
