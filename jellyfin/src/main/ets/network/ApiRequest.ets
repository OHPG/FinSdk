/**
 * An interface representing a api request params.
 */
export interface ApiRequest {

  /**
   * method
   */
  readonly method?: "GET" | "POST" | "DELETE" | "HEAD"

  /**
   * path
   */
  readonly path: string

  /**
   * params
   */
  readonly parameters?: object

  /**
   * body
   */
  readonly data?: object

}