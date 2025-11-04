import { BookDto } from "../model/BookDto";
import { BookResultDto } from "../model/BookResultDto";
import { Api } from "./Api";

export class ItemsApi extends Api {

  public async getBooks(id: string, page?: number): Promise<BookResultDto> {
    let param: Record<string, number> | undefined
    if (page) {
      param= {
        "page": page
      }
    }
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
    return this.apiClient.post({
      path: "/api/v1/books/list",
      parameters: param,
      data: data
    })
  }

  public async search(keyword: string): Promise<BookResultDto> {
    let data: Record<string, string> = {
      "fullTextSearch": keyword
    }
    let param: Record<string, number> = {
      "size": 100
    }
    return this.apiClient.post({
      path: "/api/v1/books/list",
      parameters: param,
      data: data
    })
}

  public async getBook(id: string): Promise<BookDto> {
    return this.apiClient.get({
      path: "/api/v1/books/" + id,
    })
  }

  public async getFile(id: string): Promise<string> {
    return this.apiClient.createUrl({
      path: "/api/v1/books/" + id + "/file",
    })
  }

  public async markBookReadProgress(id: string, page: number): Promise<void> {
    let data: Record<string, number | boolean> = {
      "page": page,
      "completed": false
    }
    return this.apiClient.patch({
      path: "/api/v1/books/" + id + "/read-progress",
      data: data
    })
  }

  public async markBookProgression(id: string, href: string, page: number): Promise<void> {
    let device: Record<string, string> = {
      "id": this.apiClient.deviceInfo.id,
      "name": this.apiClient.deviceInfo.name
    }
    let locator: Record<string, string | Record<string, string | number>> = {
      "href": href,
      "type":"application/xhtml+xml",
      "locations": {
        "progression": 0,
        "position": 0
      }
    }
    let data: Record<string, string | object> = {
      "device": device,
      "locator": locator,
      "modified": (new Date()).toISOString()
    }
    return this.apiClient.put({
      path: "/api/v1/books/" + id + "/progression",
      data: data
    })
  }

  public async markBookRead(id: string): Promise<void> {
    let data: Record<string, number | boolean> = {
      "completed": true
    }
    return this.apiClient.patch({
      path: "/api/v1/books/" + id + "/read-progress",
      data: data
    })
  }

  public async markBookUnread(id: string): Promise<void> {
    return this.apiClient.delete({
      path: "/api/v1/books/" + id + "/read-progress",
    })
  }

}