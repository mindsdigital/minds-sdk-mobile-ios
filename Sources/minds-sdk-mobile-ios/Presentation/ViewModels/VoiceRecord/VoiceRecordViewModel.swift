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

@available(iOS 13.0, *)
class VoiceRecordViewModel: ObservableObject {
    private var recordingDelegate: VoiceRecordingServiceDelegate
    weak var mindsDelegate: MindsSDKDelegate?
    var completion: (() -> Void?)? = nil
    private var sdk: MindsSDK_old = MindsSDK_old.shared

    @Published var audioDuration: Int = 0
    @Published var state: VoiceRecordState = .initial
    @Published var biometricsResponse: BiometricResponse? = BiometricResponse()
    @Published var livenessText: RandomSentenceId
    @Binding var voiceRecordingFlowActive: Bool
    
    init(serviceDelegate: VoiceRecordingServiceDelegate = VoiceRecordingServiceDelegateImpl(),
         mindsDelegate: MindsSDKDelegate? = nil,
         voiceRecordingFlowActive: Binding<Bool>,
         completion: (() -> Void?)? = nil) {
        self.livenessText = sdk.liveness
        self.recordingDelegate = serviceDelegate
        self.completion = completion
        self.mindsDelegate = mindsDelegate
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
    }
    
    func updateLivenessText(_ liveness: RandomSentenceId) {
        self.livenessText = liveness
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
        closeFlow()
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
                    self.closeFlow()
                } else {
                    self.mindsDelegate?.onError(response)
                    self.completion?()
                }

            case .failure(_):
                self.mindsDelegate?.onError(self.biometricsResponse!)
                self.completion?()
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

    private func closeFlow() {
        self.voiceRecordingFlowActive = false
        self.completion?()
    }
}
