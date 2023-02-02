//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation
import AVFoundation

struct GetAVAudioRecorderImpl : GetAVAudioRecorder {
    func execute() throws -> AVAudioRecorder {
        let documentPath = FileManager.default.temporaryDirectory
        let audioFilename = documentPath.appendingPathComponent("audio.wav")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: Constants.defaultSampleRate,
            AVNumberOfChannelsKey: Constants.defaultNumberOfChannels,
            AVLinearPCMBitDepthKey: Constants.defaultLinearPCMBitDepth,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        return try AVAudioRecorder(url: audioFilename, settings: settings)
    }
}
