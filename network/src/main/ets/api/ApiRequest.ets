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
   * url
   */
  readonly url?: string

  /**
   * params
   */
  readonly parameters?: object

  /**
   * Keys to exclude from query string serialization (e.g. path params already in URL).
   */
  readonly excludeParams?: Array<string>

  /**
   * body
   */
  readonly data?: object

  /**
   * Already serialized body, sent as-is by the rcp path (HttpClient.sendRaw / put / patch).
   * Takes precedence over [data] there. Lets callers sign the exact bytes that are sent.
   */
  readonly rawBody?: string

}