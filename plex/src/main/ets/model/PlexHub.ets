import { PlexMetadata } from "./PlexMetadata"

export interface PlexHub {
  'hubKey'?: string
  'key'?: string
  'title'?: string
  'type'?: string
  'hubIdentifier'?: string
  'context'?: string
  'size'?: number
  'more'?: boolean
  'style'?: string
  'promoted'?: boolean
  'Metadata'?: Array<PlexMetadata>
}
