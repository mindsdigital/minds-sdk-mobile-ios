//
//  File.swift
//  
//
//  Created by Divino Borges on 16/07/22.
//

import Foundation
import AVFAudio
#if COCOAPODS
import ffmpegkit
#else
import SwiftOGG
#endif

class ConvertAudioToOgg {
    static func convert(src: URL) -> URL {
#if COCOAPODS
        return convertFFmpeg(src: src)
#else
        return convertSwiftOGG(src: src)
#endif
    }
    
    
#if SWIFT_PACKAGE
    private static func convertSwiftOGG(src: URL) -> URL {
        let convertedAudio = URL(fileURLWithPath: NSTemporaryDirectory() + "audio.ogg")
        
        do {
            try OGGConverter.convertM4aFileToOpusOGG(src: src, dest: convertedAudio)
        } catch {
            print("Failed to convert from m4a to ogg with error \(error)")
        }
        
        return convertedAudio
    }
#endif
    
#if COCOAPODS
    private static func convertFFmpeg(src: URL) -> URL {
        let cacheManager: ClearCache
        let convertedAudio = URL(fileURLWithPath: NSTemporaryDirectory() + "audio.ogg")
        cacheManager = ClearCacheImpl()
        cacheManager.execute(url: convertedAudio)
        let arguments = "-f s16le -ar 48000 -ac 1 -i \(src) -c:a libopus \(convertedAudio)"
        let session = FFmpegKit.execute(arguments)
        let returnCode = session?.getReturnCode()
        
        if ReturnCode.isSuccess(returnCode) {
            print("Successful conversion")
        } else if ReturnCode.isCancel(returnCode) {
            print("Canceled")
        } else {
            print("Failed to convert from m4a to ogg with error")
        }
        
        return convertedAudio
    }
#endif
}
