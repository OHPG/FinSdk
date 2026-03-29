import { PlexStream } from "./PlexStream"

export interface PlexPart {
  'id'?: number
  'key'?: string
  'duration'?: number
  'file'?: string
  'size'?: number
  'container'?: string
  'videoProfile'?: string
  'protocol'?: string
  'Stream'?: Array<PlexStream>
}
