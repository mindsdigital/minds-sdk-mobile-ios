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
    func showAlert(for errorType: VoiceRecordErrorType)
    func showLoading()
    func hideLoading()
}

final class VoiceRecordViewModel {
    
    weak var mindsDelegate: MindsSDKDelegate?
    weak var delegate: VoiceRecordViewModelDelegate?

    var livenessText: RandomSentenceId
    var timerViewModel: TimerComponentViewModel
    
    private var audioDuration: Int = 0
    private var biometricsResponse: BiometricResponse? = BiometricResponse()
    private var recordingDelegate: VoiceRecordingServiceDelegate?
    private var biometricServiceFactory: BiometricServiceFactory
    
    init(livenessText: RandomSentenceId,
         serviceDelegate: VoiceRecordingServiceDelegate = VoiceRecordingServiceDelegateImpl(),
         mindsDelegate: MindsSDKDelegate? = nil,
         biometricServiceFactory: BiometricServiceFactory = BiometricServiceFactory(),
         timerViewModel: TimerComponentViewModel = .init()) {
        self.livenessText = livenessText
        self.recordingDelegate = serviceDelegate
        self.mindsDelegate = mindsDelegate
        self.biometricServiceFactory = biometricServiceFactory
        self.timerViewModel = timerViewModel
        self.timerViewModel.timerTicksWhenInvalidated = setAudioDuration
    }
    
    func getVoiceRecordingTitle() -> String {
        if(SDKDataRepository.shared.processType == MindsSDK.ProcessType.authentication){
            return MindsSDKConfigs.shared.voiceRecordingAuthenticationTitle()
        }
        return MindsSDKConfigs.shared.voiceRecordingEnrollmentTitle()
    }
    
    func updateLivenessText(_ liveness: RandomSentenceId) {
        self.livenessText = liveness
    }
    
    func isPhraseSet() -> Bool {
        return SDKDataRepository.shared.phrase != nil && !SDKDataRepository.shared.phrase!.isEmpty
    }
    
    func getPhrase() -> String {
        if (isPhraseSet()) {
            return SDKDataRepository.shared.phrase!
        }
        return livenessText.result!
    }


    func longPressStarted() {
        startRecording()
        timerViewModel.startTicking()
    }

    func longPressReleased() {
        stopRecording()
        timerViewModel.invalidateTimer()
    }

    private func startRecording() {
        recordingDelegate?.startRecording()
    }
    
    private func stopRecording() {
        recordingDelegate?.stopRecording()
    }
    
    func doBiometricsLater() {
        guard let biometricsResponse = biometricsResponse else {
            return
        }
        
        DoBiometricsLaterImpl().execute(biometricResponse: biometricsResponse,
                                        delegate: mindsDelegate)
        
        closeFlow()
    }

    private func setAudioDuration(_ duration: Int) {
        self.audioDuration = duration
        sendAudioToApiIfReachedMinDuration()
    }

    private func sendAudioToApiIfReachedMinDuration() {
        guard audioDuration >= 5 else {
            self.delegate?.showAlert(for: .invalidLength)
            return
        }

        sendAudioToApi()
    }
    
    private func sendAudioToApi() {
        delegate?.showLoading()
        
        SendAudioToApi().execute(voiceApiService: VoiceApiServiceFactory().makeVoiceApiService()) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.biometricsResponse = response
                }
                
                if let success = response.success, success {
                    self?.mindsDelegate?.onSuccess(response)
                    
                } else {
                    self?.mindsDelegate?.onError(response)
                }
                
            case .failure(let errorResponse):
                let biometricsResponse: BiometricResponse = BiometricResponse(success: false, error: ErrorResponse(code: errorResponse.code.description, description: errorResponse.description))
                self?.mindsDelegate?.onError(biometricsResponse)
            }
            
            self?.closeFlow()
        }
    }

    private func closeFlow() {
        delegate?.closeFlow()
    }
}
