export class DataTool {

  public static buildLibraryData(id: string): object {
    let operator: Record<string, string> = {
      "operator": "is",
      "value": id
    }
    let library: Record<string, object> = {
      "libraryId": operator
    }
    let anyOf: Array<Record<string, object>> = [
      library
    ]
    let allOf: Array<Record<string, object>> = [
      {
        "anyOf": anyOf
      }
    ]
    let condition: Record<string, ESObject> = {
      "allOf": allOf
    }
    let data: Record<string, ESObject> = {
      "condition": condition
    }
    return data
  }

  public static buildSeriesData(id: string): object {
    let operator: Record<string, string> = {
      "operator": "is",
      "value": id
    }
    let seriesId: Record<string, object> = {
      "seriesId": operator
    }
    let allOf: Array<Record<string, object>> = [
      seriesId
    ]
    let condition: Record<string, ESObject> = {
      "allOf": allOf
    }
    let data: Record<string, ESObject> = {
      "condition": condition
    }
    return data
  }

  public static buildPageData(page?: number): object | undefined {
    let param: Record<string, number> | undefined
    if (page) {
      param= {
        "page": page
      }
    }
    return param
  }

}