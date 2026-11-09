import { ApiError } from "@ohpg/network";
import { Api } from "./Api";

/**
 * 收藏 / 已看 / 播放进度。
 *
 * 兼容接口是否提供 Jellyfin 风格的 /Users/{uid}/FavoriteItems/{id}、/PlayedItems/{id}、/Sessions/Playing*
 * 未经验证；参考客户端 Lumy 对这些功能走的是飞牛原生接口（item/watched、media/p 等），
 * 暗示兼容接口不可用。因此本版明确抛出"暂不支持"，不做猜测实现。
 * 状态读取仍可通过 FnosBaseItem.UserData 获得（IsFavorite / Played / PlaybackPositionTicks）。
 */
export class UserDataApi extends Api {

  public async setFavorite(itemId: string, favorite: boolean): Promise<void> {
    throw new ApiError(501, "fnOS 兼容模式暂不支持收藏") as Error
  }

  public async setPlayed(itemId: string, played: boolean): Promise<void> {
    throw new ApiError(501, "fnOS 兼容模式暂不支持标记已看") as Error
  }

  public async reportProgress(itemId: string, positionMs: number): Promise<void> {
    throw new ApiError(501, "fnOS 兼容模式暂不支持上报播放进度") as Error
  }
}
