/**
 * 飞牛原生模式(/v/api/v1/*)数据模型。字段名保持服务端 snake_case。
 * 字段来源为开源客户端源码阅读，未经真实服务器验证；大部分字段按可选处理。
 * 时间单位：ts / duration 为秒。
 */

/** 统一响应外壳。 */
export interface FnosNativeResponse<T> {
  code: number
  msg?: string
  data?: T
}

/** 空对象请求体/响应体占位。 */
export interface FnosNativeEmpty {
}

// ---------------------------------------------------------------- 登录 / 用户

export interface FnosNativeLoginRequest {
  username: string
  password: string
  app_name: string
}

export interface FnosNativeLoginData {
  token: string
}

export interface FnosNativeUserInfo {
  guid: string
  username: string
  nickname?: string
  is_admin?: number
}

// ---------------------------------------------------------------- 媒体库

export interface FnosNativeMediaDb {
  guid: string
  title: string
  /** Movie / TV / Mix / IPTV / Others */
  category: string
  poster?: string
}

// ---------------------------------------------------------------- 条目

export interface FnosNativeItemTags {
  type?: string
  genres?: number[]
  watched?: number
}

export interface FnosNativeItemListRequest {
  ancestor_guid?: string
  page: number
  page_size: number
  sort_column?: string
  sort_type?: string
  exclude_grouped_video?: number
  tags?: FnosNativeItemTags
}

export interface FnosNativeItem {
  guid: string
  /** Movie / TV / Season / Episode / Video ... */
  type: string
  title: string
  tv_title?: string
  parent_guid?: string
  ancestor_guid?: string
  poster?: string
  backdrop?: string
  overview?: string
  is_favorite?: number
  watched?: number
  /** 已播放位置，秒 */
  ts?: number
  /** 时长，秒 */
  duration?: number
  vote_average?: string
  release_date?: string
  air_date?: string
  season_number?: number
  episode_number?: number
  number_of_seasons?: number
  number_of_episodes?: number
  genres?: string[]
  runtime?: number
  create_time?: number
  update_time?: number
}

export interface FnosNativeItemListData {
  list: FnosNativeItem[]
  total?: number
}

export interface FnosNativeSearchData {
  list?: FnosNativeItem[]
}

export interface FnosNativePerson {
  guid?: string
  name: string
  alias?: string
  role?: string
  /** Actor / Director ... */
  type?: string
  profile_path?: string
}

export interface FnosNativePersonListData {
  list?: FnosNativePerson[]
}

export interface FnosNativeGenre {
  id: number
  name: string
}

export interface FnosNativeGenresData {
  genres?: FnosNativeGenre[]
}

// ---------------------------------------------------------------- 播放

export interface FnosNativeItemGuidRequest {
  item_guid: string
}

export interface FnosNativePlayInfo {
  item_guid?: string
  media_guid?: string
  video_guid?: string
  audio_guid?: string
  subtitle_guid?: string
  ts?: number
  duration?: number
}

export interface FnosNativeVideoStream {
  guid: string
  media_guid?: string
  codec_name?: string
  width?: number
  height?: number
  color_range_type?: string
}

export interface FnosNativeAudioStream {
  guid: string
  media_guid?: string
  codec_name?: string
  language?: string
  title?: string
}

export interface FnosNativeSubtitleStream {
  guid: string
  media_guid?: string
  codec_name?: string
  language?: string
  title?: string
  is_external?: number
}

export interface FnosNativeStreamFile {
  guid: string
  file_name?: string
  path?: string
  size?: number
  duration?: number
}

export interface FnosNativeStreamListData {
  files?: FnosNativeStreamFile[]
  video_streams?: FnosNativeVideoStream[]
  audio_streams?: FnosNativeAudioStream[]
  subtitle_streams?: FnosNativeSubtitleStream[]
}

export interface FnosNativePlayRecordRequest {
  item_guid: string
  media_guid: string
  video_guid: string
  audio_guid: string
  subtitle_guid: string
  /** 播放位置，秒 */
  ts: number
  /** 总时长，秒 */
  duration: number
}
