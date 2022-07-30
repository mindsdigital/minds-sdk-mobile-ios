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
    private var recordingDelegate: VoiceRecordingServiceDelegate
    
    @Published var state = VoiceRecordState.initial
    @Published var biometricsResponse: BiometricResponse? = BiometricResponse()
    
    init(serviceDelegate: VoiceRecordingServiceDelegate = VoiceRecordingServiceDelegateImpl()) {
        self.recordingDelegate = serviceDelegate
    }
    
    func startRecording() {
        recordingDelegate.startRecording()
        state = VoiceRecordState.recording
    }
    
    func stopRecording() {
        recordingDelegate.stopRecording()
        state = VoiceRecordState.loading
    }
    
    func doBiometricsLater() {
        DoBiometricsLaterImpl().execute(biometricResponse: biometricsResponse!)
    }
    
    func livenessText() -> String {
        return MindsSDK.shared.liveness.result ?? ""
    }
    
    func audioDuration() -> Double {
        return recordingDelegate.audioDuration()
    }
    
    func sendAudioToApi() {
        SendAudioToApi().execute(biometricsService: makeBiometricService()) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.biometricsResponse = response
                }
                
                if response.success ?? false {
                    MindsSDK.shared.onBiometricsReceive?(response)
                } else {
                    self.updateStateOnMainThread(to: .error)
                }
                
            case .failure(_):
                self.updateStateOnMainThread(to: .error)
            }
        }
    }
    
    private func updateStateOnMainThread(to newState: VoiceRecordState) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }
}
