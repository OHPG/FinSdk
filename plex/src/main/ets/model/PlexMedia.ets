import { PlexPart } from "./PlexPart"

export interface PlexMedia {
  'id'?: number
  'duration'?: number
  'bitrate'?: number
  'width'?: number
  'height'?: number
  'aspectRatio'?: number
  'audioChannels'?: number
  'audioCodec'?: string
  'videoCodec'?: string
  'videoResolution'?: string
  'container'?: string
  'videoFrameRate'?: string
  'videoProfile'?: string
  'protocol'?: string
  'indirect'?: boolean
  'Part'?: Array<PlexPart>
}
