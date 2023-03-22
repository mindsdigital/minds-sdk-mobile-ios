//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation
import AVFoundation

struct StopRecordingImpl : StopRecording {    
    func execute(avAudioRecorder: AVAudioRecorder, avAudioSession: AVAudioSession) {
        avAudioRecorder.stop()
        do {
            try avAudioSession.setActive(false)
        } catch {
            debugPrint("Error stopping recording: \(error.localizedDescription)")
        }
    }
}
