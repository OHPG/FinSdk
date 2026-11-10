import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { util } from '@kit.ArkTS'

/**
 * UTF-8 MD5，输出小写 hex。sdk 不依赖 framework 的 MD5，这里自带一份。
 */
export function fnosMd5Hex(text: string): string {
  let encoder = new util.TextEncoder()
  let data: Uint8Array = encoder.encodeInto(text)
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
