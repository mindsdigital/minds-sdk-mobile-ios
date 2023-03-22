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
    private var avRecorder: AVAudioRecorder?
    
    func startRecording() {
        do {
            let avSession = try GetAVAudioSessionImpl().execute()
            avRecorder = try GetAVAudioRecorderImpl().execute()
            StartRecordingImpl().execute(avAudioRecorder: avRecorder!, avAudioSession: avSession)
                
        } catch {
            debugPrint("Error starting recording: \(error)")
        }
    }
    
    func stopRecording() {
        guard let avRecorder = avRecorder else {
            return
        }
        
        do {
            let avSession = try GetAVAudioSessionImpl().execute()
            StopRecordingImpl().execute(avAudioRecorder: avRecorder, avAudioSession: avSession)
        } catch {
            debugPrint("Error stopping recording: \(error)")
        }
        
        self.avRecorder = nil
    }
    
    func audioDuration() -> Double {
        return 1.0
    }
}
