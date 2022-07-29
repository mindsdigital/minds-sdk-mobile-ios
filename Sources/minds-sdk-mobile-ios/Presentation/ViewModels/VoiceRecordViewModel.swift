//
//  File.swift
//  
//
//  Created by Divino Borges on 29/07/22.
//

import Foundation
import AVFAudio
import UIKit
import SwiftUI

enum VoiceRecordState {
    case initial, recording, loading, error
    
    var isError: Binding<Bool> {
        get {
            Binding(
                get: {
                    self == .error
                },
                set: {_ in }
            )
        }
    }
}

@MainActor
class VoiceRecordViewModel: ObservableObject {
    @Published var state = VoiceRecordState.initial
    @Published var biometricsResponse: BiometricResponse? = nil
    
    var avrecorder: AVAudioRecorder? = nil
    
    func startRecording() {
        state = VoiceRecordState.recording
        
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
                state = VoiceRecordState.loading
    }
    
    func doBiometricsLater() {
        DoBiometricsLaterImpl().execute(biometricResponse: biometricsResponse!)
    }
    
    func sendAudioToApi() {
        
    }
    
    func livenessText() -> String {
        return ""
    }
    
    func audioDuration() -> Double {
        return 1.0
    }
}
