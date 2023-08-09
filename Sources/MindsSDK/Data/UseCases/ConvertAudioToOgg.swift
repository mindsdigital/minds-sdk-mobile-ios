//
//  File.swift
//  
//
//  Created by Divino Borges on 16/07/22.
//

import Foundation
import AVFAudio
import ffmpegkit

class ConvertAudioToOgg {
    static func convert(src: URL) -> URL {
        let cacheManager: ClearCache
        let convertedAudio = URL(fileURLWithPath: NSTemporaryDirectory() + "audio.ogg")
        cacheManager = ClearCacheImpl()
        cacheManager.execute(url: convertedAudio)
        let arguments = "-f s16le -ar 48000 -ac 1 -i \(src) -c:a libopus \(convertedAudio)"
        let session = FFmpegKit.execute(arguments)
        let returnCode = session?.getReturnCode()

             if ReturnCode.isSuccess(returnCode) {
                 print("Successful conversion")
                 // SUCCESS
             } else if ReturnCode.isCancel(returnCode) {
                 print(false, "Canceled")
             } else {
                 // FAILURE
                 print(false, "Failed to convert from wav to ogg with error")
             }
        
        return convertedAudio
    }
}
