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

  public static buildResumeData(ids: Array<string>): object {
    let libraryArray: Array<Record<string, object>> = []
    for (const id of ids) {
      let operator: Record<string, string> = {
        "operator": "is",
        "value": id
      }
      let libraryId: Record<string, object> = {
        "libraryId": operator
      }
      libraryArray.push(libraryId)
    }
    let anyOf: Record<string, object> = {
      "anyOf": libraryArray
    }
    let operator: Record<string, string> = {
      "operator": "is",
      "value": "IN_PROGRESS"
    }
    let readStatus: Record<string, object> = {
      "readStatus": operator
    }
    let allOf: Array<object> = [
      anyOf, readStatus
    ]
    let condition: Record<string, ESObject> = {
      "allOf": allOf
    }
    let data: Record<string, ESObject> = {
      "condition": condition
    }
    return data
  }

  public static buildNewData(ids: Array<string>): object {
    let libraryArray: Array<Record<string, object>> = []
    for (const id of ids) {
      let operator: Record<string, string> = {
        "operator": "is",
        "value": id
      }
      let libraryId: Record<string, object> = {
        "libraryId": operator
      }
      libraryArray.push(libraryId)
    }
    let anyOf: Record<string, object> = {
      "anyOf": libraryArray
    }
    let allOf: Array<object> = [
      anyOf
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
    let param: Record<string, number | string> | undefined
    if (page) {
      param= {
        "page": page,
        "size": 20,
        "sort": encodeURIComponent("metadata.numberSort,asc")
      }
    }
    return param
  }

}