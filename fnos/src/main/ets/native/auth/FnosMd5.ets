import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { util } from '@kit.ArkTS'

/** md5("") 的标准值。cryptoFramework 的 updateSync 不接受 0 长度数据（抛 invalid parameters），需特判。 */
const MD5_EMPTY = 'd41d8cd98f00b204e9800998ecf8427e'

/**
 * UTF-8 MD5，输出小写 hex。sdk 不依赖 framework 的 MD5，这里自带一份。
 */
export function fnosMd5Hex(text: string): string {
  // 空 / undefined 输入：updateSync 对空 Uint8Array 会抛 invalid parameters，直接返回 md5("")。
  if (text === undefined || text === null || text.length === 0) {
    return MD5_EMPTY
  }
  let encoder = new util.TextEncoder()
  let data: Uint8Array = encoder.encodeInto(text)
  if (data.length === 0) {
    return MD5_EMPTY
  }
  let md = cryptoFramework.createMd('MD5')
  md.updateSync({ data: data })
  let bytes: Uint8Array = md.digestSync().data
  let hex = ''
  for (let i = 0; i < bytes.length; i++) {
    let h = bytes[i].toString(16)
    hex += h.length === 1 ? '0' + h : h
  }
  return hex
}
