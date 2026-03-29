export interface PlexAccountResponse {
  'user'?: PlexAccount
}

export interface PlexAccount {
  'id'?: number
  'uuid'?: string
  'email'?: string
  'username'?: string
  'title'?: string
  'thumb'?: string
  'authToken'?: string
  'authentication_token'?: string
}
