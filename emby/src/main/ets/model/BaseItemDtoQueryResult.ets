import { BaseItemDto } from "./BaseItemDto";

/**
 * @export
 * @interface BaseItemDtoQueryResult
 */
export interface BaseItemDtoQueryResult {
  'Items'?: Array<BaseItemDto> | null;
  'TotalRecordCount'?: number;
  'StartIndex'?: number;
}
