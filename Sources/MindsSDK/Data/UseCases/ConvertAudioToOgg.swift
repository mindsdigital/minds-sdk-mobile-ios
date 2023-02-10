//
//  File.swift
//  
//
//  Created by Divino Borges on 16/07/22.
//

import Foundation
import SwiftOGG

class ConvertAudioToOgg {
    static func convert(src: URL) -> URL {
        let convertedAudio = URL(fileURLWithPath: NSTemporaryDirectory() + "audio.ogg")
        
        do {
            try OGGConverter.convertM4aFileToOpusOGG(src: src, dest: convertedAudio)
        } catch {
            print(false, "Failed to convert from wav to ogg with error \(error)")
        }
        
        return convertedAudio
    }
}
