import { BookDto } from "../model/BookDto";
import { BookResultDto } from "../model/BookResultDto";
import { ProgressDto } from "../model/ProgressDto";
import { DataTool } from "../tool/DataTool";
import { Api } from "./Api";

export class ItemsApi extends Api {

  public async getLibraryBooks(id: string, page?: number, pageSize?: number): Promise<BookResultDto> {
    return this.apiClient.post({
      path: "/api/v1/books/list",
      parameters: DataTool.buildPageData(page, pageSize),
      data: DataTool.buildLibraryData(id)
    })
  }

  public async getResumeBooks(ids: Array<string>): Promise<BookResultDto> {
    let params: Record<string, string> = {
      "sort": encodeURIComponent("readProgress.readDate,desc")
    }
    return this.apiClient.post({
      path: "/api/v1/books/list",
      parameters: params,
      data: DataTool.buildResumeData(ids)
    })
  }

  public async getNewBooks(ids: Array<string>): Promise<BookResultDto> {
    let params: Record<string, string> = {
      "sort": encodeURIComponent("createdDate,desc")
    }
    return this.apiClient.post({
      path: "/api/v1/books/list",
      parameters: params as ESObject as object,
      data: DataTool.buildNewData(ids)
    })
  }

  public async getNewSeries(ids: Array<string>): Promise<BookResultDto> {
    let params: Array<Record<string, string>> = []
    ids.forEach((id) => {
      params.push({"library_id": id})
    })
    params.push({"oneshot" : "false"})
    return this.apiClient.get({
      path: "/api/v1/series/new",
      parameters: params as ESObject as object,
    })
  }

  public async getUpdateSeries(ids: Array<string>): Promise<BookResultDto> {
    let params: Array<Record<string, string>> = []
    ids.forEach((id) => {
      params.push({"library_id": id})
    })
    params.push({"oneshot" : "false"})
    return this.apiClient.get({
      path: "/api/v1/series/updated",
      parameters: params as ESObject as object,
    })
  }

  public async getSeriesBooks(id: string, page?: number, pageSize?: number): Promise<BookResultDto> {
    return this.apiClient.post({
      path: "/api/v1/books/list",
      parameters: DataTool.buildPageData(page, pageSize),
      data: DataTool.buildSeriesData(id)
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
    let progressDto: ProgressDto = {
      device: {
        "id": this.apiClient.deviceInfo.id,
        "name": this.apiClient.deviceInfo.name
      },
      locator: {
        "href": href,
        title: undefined,
        "type":"application/xhtml+xml",
        "locations": {
          fragments: [],
          position: page,
          progression: 0,
          totalProgression: 0
        }
      },
      modified: (new Date()).toISOString()
    }
    return this.apiClient.put({
      path: "/api/v1/books/" + id + "/progression",
      data: progressDto
    })
  }

  public async getBookProgression(id: string): Promise<ProgressDto> {
    return this.apiClient.get({
      path: "/api/v1/books/" + id + "/progression",
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