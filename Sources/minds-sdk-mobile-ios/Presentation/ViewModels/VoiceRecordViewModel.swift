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
        switch self {
        case .error:
            return .constant(true)
        default:
            return .constant(false)
        }
    }
}

class VoiceRecordViewModel: ObservableObject {
    private var recordingDelegate: VoiceRecordingServiceDelegate
    weak var mindsDelegate: MindsSDKDelegate?
    var completion: (() -> Void?)? = nil

    @Published var state: VoiceRecordState = .initial
    @Published var biometricsResponse: BiometricResponse? = BiometricResponse()
    
    init(serviceDelegate: VoiceRecordingServiceDelegate = VoiceRecordingServiceDelegateImpl(),
         mindsDelegate: MindsSDKDelegate? = nil,
         completion: (() -> Void?)? = nil) {
        self.recordingDelegate = serviceDelegate
        self.completion = completion
        self.mindsDelegate = mindsDelegate
    }
    
    func startRecording() {
        recordingDelegate.startRecording()
        self.updateStateOnMainThread(to: .recording)
    }
    
    func stopRecording() {
        recordingDelegate.stopRecording()
        self.updateStateOnMainThread(to: .loading)
        sendAudioToApi()
    }
    
    func doBiometricsLater() {
//        DoBiometricsLaterImpl().execute(biometricResponse: biometricsResponse!)
        self.completion?()
    }
    
    func livenessText() -> String {
        return MindsSDK.shared.liveness.result ?? ""
    }
    
    // not working
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
                
                if let success = response.success, success {
                    self.mindsDelegate?.onSuccess(response)
                    self.updateStateOnMainThread(to: .initial)
                    self.completion?()
                } else {
                    self.mindsDelegate?.onError(response)
                    self.updateStateOnMainThread(to: .error)
                }

            case .failure(_):
                self.updateStateOnMainThread(to: .error)
                print("--- SDK SERVICE ERROR")
            }
        }
    }
    
    private func updateStateOnMainThread(to newState: VoiceRecordState) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }
}
