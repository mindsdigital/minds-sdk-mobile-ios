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

class VoiceRecordViewModel: ObservableObject {
    private var recordingDelegate: VoiceRecordingServiceDelegate
    weak var mindsDelegate: MindsSDKDelegate?
    var completion: (() -> Void?)? = nil

    @Published var audioDuration: Int = 0
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
    }
    
    func doBiometricsLater() {
        guard let biometricsResponse = biometricsResponse else {
            return
        }

        DoBiometricsLaterImpl().execute(biometricResponse: biometricsResponse,
                                        delegate: mindsDelegate)
        self.completion?()
    }
    
    func livenessText() -> String {
        return MindsSDK.shared.liveness.result ?? ""
    }

    func setAudioDuration(_ duration: Int) {
        self.audioDuration = duration
        sendAudioToApiIfReachedMinDuration()
    }

    func sendAudioToApiIfReachedMinDuration() {
        guard audioDuration >= 5 else {
            self.updateStateOnMainThread(to: .error(.invalidLength))
            return
        }

        sendAudioToApi()
    }
    
    private func sendAudioToApi() {

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
//                    self.updateStateOnMainThread(to: .error(.generic))
                    self.completion?()
                }

            case .failure(_):
                self.updateStateOnMainThread(to: .error(.generic))
                print("--- SDK SERVICE ERROR")
            }
        }
    }
    
    private func updateStateOnMainThread(to newState: VoiceRecordState) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }

    func alert() -> Alert {
        if case let VoiceRecordState.error(errorType) = state {
            switch errorType {
            case .invalidLength:
                return invalidLengthAlert(errorType)
            case .generic:
                return genericAlert(errorType)
            }
        }

        return Alert(title: Text(""),
                     message: Text(""),
                     primaryButton: .cancel(),
                     secondaryButton: .cancel())
    }

    private func invalidLengthAlert(_ errorType: VoiceRecordErrorType) -> Alert {
        return Alert(title: Text(errorType.title),
                     message: Text(errorType.subtitle),
                     dismissButton: .cancel(Text(errorType.dismissButtonLabel)))
    }

    private func genericAlert(_ errorType: VoiceRecordErrorType) -> Alert {
        return Alert(title: Text(errorType.title),
                     message: Text(errorType.subtitle),
                     primaryButton: .destructive(Text(errorType.dismissButtonLabel),
                                                 action: doBiometricsLater),
                     secondaryButton: .cancel(Text(errorType.primaryActionLabel)))
    }
}
