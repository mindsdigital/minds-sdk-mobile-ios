//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 27/07/22.
//

import Foundation
import AVFAudio

protocol VoiceRecordingServiceDelegate: AnyObject {
    func startRecording()
    func stopRecording()
    func audioDuration() -> Double
}

class VoiceRecordingServiceDelegateImpl: VoiceRecordingServiceDelegate {
    var avrecorder: AVAudioRecorder? = nil

    func startRecording() {
        do {
            let avsession = try GetAVAudioSessionImpl().execute()
            avrecorder = try GetAVAudioRecorderImpl().execute()
            StartRecordingImpl().execute(avAudioRecorder: avrecorder!, avAudioSession: avsession)
                
        } catch {
            print("error")
        }
    }
    
    func stopRecording() {
        StopRecordingImpl().execute(avAudioRecorder: avrecorder!)
    }
    
    func audioDuration() -> Double {
        return 1.0
    }
}
