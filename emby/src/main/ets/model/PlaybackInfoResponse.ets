import { MediaSourceInfo } from "./MediaSourceInfo";

/**
 * Class PlaybackInfoResponse.
 * @export
 * @interface PlaybackInfoResponse
 */
export interface PlaybackInfoResponse {
  'MediaSources'?: Array<MediaSourceInfo>;
  'PlaySessionId'?: string | null;
}
