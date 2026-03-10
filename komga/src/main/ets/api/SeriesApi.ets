import { BookResultDto } from "../model/BookResultDto";
import { DataTool } from "../tool/DataTool";
import { Api } from "./Api";

export class SeriesApi extends Api {

  public async list(id: string, page?: number, pageSize?: number): Promise<BookResultDto> {
    return this.apiClient.post({
      path: "/api/v1/series/list",
      parameters: DataTool.buildPageData(page, pageSize),
      data: DataTool.buildLibraryData(id)
    })
  }

  public async seriesBooks(id: string, page?: number, pageSize?: number): Promise<BookResultDto> {
    return this.apiClient.post({
      path: "/api/v1/books/list",
      parameters: DataTool.buildPageData(page, pageSize),
      data: DataTool.buildSeriesData(id)
    })
  }

}