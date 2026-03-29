import { PlexMetadata } from "./PlexMetadata"
import { PlexDirectory } from "./PlexDirectory"
import { PlexHub } from "./PlexHub"

export interface PlexResponse {
  'MediaContainer'?: PlexMediaContainer
}

export interface PlexMediaContainer {
  'size'?: number
  'totalSize'?: number
  'offset'?: number
  'allowSync'?: boolean
  'identifier'?: string
  'librarySectionID'?: number
  'librarySectionTitle'?: string
  'librarySectionUUID'?: string
  'mediaTagPrefix'?: string
  'mediaTagVersion'?: string
  'title1'?: string
  'title2'?: string
  'viewGroup'?: string
  'machineIdentifier'?: string
  'friendlyName'?: string
  'version'?: string
  'Metadata'?: Array<PlexMetadata>
  'Directory'?: Array<PlexDirectory>
  'Hub'?: Array<PlexHub>
}
