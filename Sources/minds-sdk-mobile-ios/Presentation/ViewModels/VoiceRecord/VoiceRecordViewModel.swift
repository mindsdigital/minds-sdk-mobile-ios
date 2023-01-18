//
//  VoiceRecordViewModel.swift
//
//
//  Created by Divino Borges on 29/07/22.
//

import Foundation
import AVFAudio
import UIKit
import SwiftUI

protocol VoiceRecordViewModelDelegate: AnyObject {
    func closeFlow()
}

final class VoiceRecordViewModel {
    
    weak var mindsDelegate: MindsSDKDelegate?
    weak var delegate: VoiceRecordViewModelDelegate?

    var audioDuration: Int = 0
    var state: VoiceRecordState = .initial
    var biometricsResponse: BiometricResponse? = BiometricResponse()
    var livenessText: RandomSentenceId

    private var recordingDelegate: VoiceRecordingServiceDelegate
    private var biometricServiceFactory: BiometricServiceFactory
    
    init(livenessText: RandomSentenceId,
         serviceDelegate: VoiceRecordingServiceDelegate = VoiceRecordingServiceDelegateImpl(),
         mindsDelegate: MindsSDKDelegate? = nil,
         biometricServiceFactory: BiometricServiceFactory = BiometricServiceFactory()) {
        self.livenessText = livenessText
        self.recordingDelegate = serviceDelegate
        self.mindsDelegate = mindsDelegate
        self.biometricServiceFactory = biometricServiceFactory
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
        
        sendAudioToApi()
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
        SendAudioToApi().execute(biometricsService: biometricServiceFactory.makeBiometricService()) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.biometricsResponse = response
                }

                if let success = response.success, success {
                    self?.mindsDelegate?.onSuccess(response)
                    self?.updateStateOnMainThread(to: .initial)
                    self?.closeFlow()
                } else {
                    self?.mindsDelegate?.onError(response)
                }

            case .failure(_):
                guard let self = self,
                      let biometricsResponse: BiometricResponse = self.biometricsResponse else { return }
                self.mindsDelegate?.onError(biometricsResponse)
            }
        }
    }
    
    private func updateStateOnMainThread(to newState: VoiceRecordState) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }

    private func closeFlow() {
        delegate?.closeFlow()
    }
    
//    func alert() -> Alert {
//        if case let VoiceRecordState.error(errorType) = state {
//            switch errorType {
//            case .invalidLength:
//                return invalidLengthAlert(errorType)
//            }
//        }
//
//        return Alert(title: Text(""),
//                     message: Text(""),
//                     primaryButton: .cancel(),
//                     secondaryButton: .cancel())
//    }
//
//    private func invalidLengthAlert(_ errorType: VoiceRecordErrorType) -> Alert {
//        return Alert(title: Text(errorType.title),
//                     message: Text(errorType.subtitle),
//                     dismissButton: .cancel(Text(errorType.dismissButtonLabel)))
//    }

}
