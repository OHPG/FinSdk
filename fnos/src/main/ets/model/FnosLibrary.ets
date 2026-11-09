import { FnosLibraryType } from "./FnosEnums";

/** 媒体库（UserViews 条目 + 通过首条 Item 推断的类型）。 */
export interface FnosLibrary {
  readonly id: string
  readonly name: string
  readonly type: FnosLibraryType
}
