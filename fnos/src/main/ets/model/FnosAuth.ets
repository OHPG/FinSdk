/** GET /System/Info/Public 返回（免登录）。 */
export interface FnosPublicSystemInfo {
  'Id'?: string;
  'ServerName'?: string;
  'Version'?: string;
  'ProductName'?: string | null;
  'OperatingSystem'?: string | null;
}

/**
 * POST /Users/AuthenticateByName 请求体。
 * 字段 Username / Pw 取自 Lumy FnOsDtos.kt（命名策略首字母大写），未经真实服务器验证。
 */
export interface FnosAuthenticateRequest {
  'Username': string;
  'Pw': string;
}

export interface FnosUserDto {
  'Id'?: string;
  'Name'?: string;
}

export interface FnosAuthenticationResult {
  'AccessToken'?: string;
  'User'?: FnosUserDto;
  'ServerId'?: string | null;
}
