//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation
import AVFoundation

struct StartRecordingImpl : StartRecording {
    func execute(avAudioRecorder: AVAudioRecorder, avAudioSession: AVAudioSession) {
        avAudioRecorder.prepareToRecord()
        avAudioRecorder.record()
    }
}
