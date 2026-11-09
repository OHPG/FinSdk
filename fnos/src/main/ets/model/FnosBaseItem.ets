/**
 * fnOS 兼容接口 Jellyfin 风格 BaseItem（PascalCase，时间单位 100ns tick）。
 * 字段来源：Lumy Player FnOsDtos.kt，未经真实服务器验证。
 */
export interface FnosUserData {
  'IsFavorite'?: boolean;
  'PlaybackPositionTicks'?: number;
  'Played'?: boolean;
  'UnplayedItemCount'?: number | null;
  'LastPlayedDate'?: string | null;
}

export interface FnosNameDto {
  'Name'?: string;
}

export interface FnosPerson {
  'Id'?: string;
  'Name'?: string;
  'Role'?: string | null;
  /** Actor, Director, Writer ... */
  'Type'?: string;
  'PrimaryImageTag'?: string | null;
}

export interface FnosChapter {
  'StartPositionTicks'?: number;
  'Name'?: string | null;
  'ImageTag'?: string | null;
  /** Chapter, IntroStart, IntroEnd, CreditsStart */
  'MarkerType'?: string | null;
}

export interface FnosMediaStream {
  /** Video, Audio, Subtitle, EmbeddedImage */
  'Type'?: string;
  'Index'?: number;
  'Codec'?: string | null;
  'Language'?: string | null;
  'DisplayTitle'?: string | null;
  'Title'?: string | null;
  'IsDefault'?: boolean;
  'IsForced'?: boolean;
  'IsExternal'?: boolean;
  'Channels'?: number | null;
  'Width'?: number | null;
  'Height'?: number | null;
  'BitDepth'?: number | null;
  'RealFrameRate'?: number | null;
  'AverageFrameRate'?: number | null;
  'Profile'?: string | null;
  /** SDR, HDR10, HDR10Plus, HLG, DOVI ... */
  'VideoRangeType'?: string | null;
  'VideoRange'?: string | null;
  'DvProfile'?: number | null;
  'BitRate'?: number | null;
  'SampleRate'?: number | null;
}

export interface FnosMediaSource {
  'Id'?: string;
  'Name'?: string | null;
  /** 可能是逗号分隔的多个容器名，取第一个 */
  'Container'?: string | null;
  'Size'?: number | null;
  'Bitrate'?: number | null;
  'Path'?: string | null;
  'RunTimeTicks'?: number | null;
  'MediaStreams'?: FnosMediaStream[];
  'DefaultAudioStreamIndex'?: number | null;
  'DefaultSubtitleStreamIndex'?: number | null;
}

export interface FnosBaseItem {
  'Id'?: string;
  'Name'?: string;
  /** Movie, Series, Season, Episode, BoxSet, Playlist, CollectionFolder ... */
  'Type'?: string;
  /** 视图的 collectionType：movies / tvshows / music ... */
  'CollectionType'?: string | null;
  'MediaType'?: string | null;
  'ParentId'?: string | null;
  'SeriesId'?: string | null;
  'SeriesName'?: string | null;
  'SeasonId'?: string | null;
  'IndexNumber'?: number | null;
  'ParentIndexNumber'?: number | null;
  'ProductionYear'?: number | null;
  'SortName'?: string | null;
  'DateCreated'?: string | null;
  'PremiereDate'?: string | null;
  'Overview'?: string | null;
  'RunTimeTicks'?: number | null;
  'ImageTags'?: Record<string, string>;
  'BackdropImageTags'?: string[];
  'ParentBackdropItemId'?: string | null;
  'ParentBackdropImageTags'?: string[];
  'SeriesPrimaryImageTag'?: string | null;
  'ParentThumbItemId'?: string | null;
  'ParentThumbImageTag'?: string | null;
  'UserData'?: FnosUserData | null;
  'ChildCount'?: number | null;
  'RecursiveItemCount'?: number | null;
  // 详情字段
  'Taglines'?: string[];
  'OfficialRating'?: string | null;
  'CommunityRating'?: number | null;
  'Genres'?: string[];
  'People'?: FnosPerson[];
  'Studios'?: FnosNameDto[];
  'MediaSources'?: FnosMediaSource[];
  'Chapters'?: FnosChapter[];
}

export interface FnosItemsResult {
  'Items'?: FnosBaseItem[];
  'TotalRecordCount'?: number | null;
}
