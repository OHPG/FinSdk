import { BookDto } from "../model/BookDto";
import { BookResultDto } from "../model/BookResultDto";
import { Api } from "./Api";

export class ItemsApi extends Api {

  public async getBooks(id: string): Promise<BookResultDto> {
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

}