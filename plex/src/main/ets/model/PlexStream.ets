export interface PlexStream {
  'id'?: number
  'streamType'?: number  // 1=video, 2=audio, 3=subtitle
  'default'?: boolean
  'codec'?: string
  'index'?: number
  'bitrate'?: number
  'language'?: string
  'languageCode'?: string
  'languageTag'?: string
  'title'?: string
  'displayTitle'?: string
  'selected'?: boolean
  'channels'?: number
  'samplingRate'?: number
  'bitDepth'?: number
  'chromaSubsampling'?: string
  'colorSpace'?: string
  'width'?: number
  'height'?: number
  'profile'?: string
  'level'?: number
  'key'?: string  // subtitle download key
  'forced'?: boolean
  'headerCompression'?: boolean
  'videoRange'?: string
}
