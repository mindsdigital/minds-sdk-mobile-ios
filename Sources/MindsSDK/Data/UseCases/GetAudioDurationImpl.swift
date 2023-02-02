//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation

struct GetAudioDurationImpl : GetAudioDuration {
    func execute(file: URL) -> Double {
        do {
            guard let fileSize = try FileManager.default.attributesOfItem(atPath: file.path)[FileAttributeKey.size] as? UInt64 else { return 0.0 }
            
            return Double((Int(truncatingIfNeeded: fileSize) / (Constants.defaultSampleRate * Constants.defaultNumberOfChannels * (Constants.defaultLinearPCMBitDepth / 8))))
            
        } catch {
            return 0.0
        }
    }
}
