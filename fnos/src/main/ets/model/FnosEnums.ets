/** 图片类型，对应 /Items/{id}/Images/{type} */
export enum FnosImageType {
  Primary = 'Primary',
  Backdrop = 'Backdrop',
  Thumb = 'Thumb',
  Logo = 'Logo'
}

/** 媒体库类型（仅电影与剧集库对外展示）。 */
export enum FnosLibraryType {
  Movie = 'movie',
  TvShow = 'tvshow'
}

/** 100ns tick 与毫秒互转（1ms = 10000 ticks）。 */
export const FNOS_TICKS_PER_MS: number = 10000

export function fnosTicksToMs(ticks?: number | null): number {
  return ticks ? Math.floor(ticks / FNOS_TICKS_PER_MS) : 0
}

export function fnosMsToTicks(ms: number): number {
  return Math.floor(ms * FNOS_TICKS_PER_MS)
}
