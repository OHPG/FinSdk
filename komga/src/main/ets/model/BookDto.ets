import { MediaDto } from "./MediaDto"
import { MetadataDto } from "./MetadataDto"

export interface BookDto {
  id: string
  seriesId: string
  seriesTitle: string
  libraryId: string
  name: string
  url: string
  number: number
  created: string
  lastModified: string
  fileLastModified: string
  sizeBytes: number
  size: string
  media: MediaDto,
  metadata: MetadataDto,
  readProgress: object,
  deleted: boolean
  fileHash: string
  oneshot: boolean
}