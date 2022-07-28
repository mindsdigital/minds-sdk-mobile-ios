//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation
import AVFoundation

struct StopRecordingImpl : StopRecording {    
    func execute(avAudioRecorder: AVAudioRecorder) {
        avAudioRecorder.stop()
    }
}
