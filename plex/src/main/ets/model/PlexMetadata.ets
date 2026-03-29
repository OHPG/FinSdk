import { PlexMedia } from "./PlexMedia"
import { PlexTag } from "./PlexTag"
import { PlexRole } from "./PlexRole"

export interface PlexMetadata {
  'ratingKey'?: string
  'key'?: string
  'parentRatingKey'?: string
  'grandparentRatingKey'?: string
  'guid'?: string
  'slug'?: string
  'studio'?: string
  'type'?: string
  'title'?: string
  'titleSort'?: string
  'originalTitle'?: string
  'contentRating'?: string
  'summary'?: string
  'rating'?: number
  'audienceRating'?: number
  'viewOffset'?: number
  'viewCount'?: number
  'lastViewedAt'?: number
  'year'?: number
  'tagline'?: string
  'thumb'?: string
  'art'?: string
  'parentThumb'?: string
  'grandparentThumb'?: string
  'grandparentArt'?: string
  'grandparentTitle'?: string
  'parentTitle'?: string
  'parentKey'?: string
  'grandparentKey'?: string
  'duration'?: number
  'originallyAvailableAt'?: string
  'addedAt'?: number
  'updatedAt'?: number
  'index'?: number
  'parentIndex'?: number
  'leafCount'?: number
  'viewedLeafCount'?: number
  'childCount'?: number
  'Media'?: Array<PlexMedia>
  'Genre'?: Array<PlexTag>
  'Director'?: Array<PlexTag>
  'Writer'?: Array<PlexTag>
  'Country'?: Array<PlexTag>
  'Collection'?: Array<PlexTag>
  'Role'?: Array<PlexRole>
}
