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

enum VoiceRecordErrorType {
    case invalidLength, generic

    var title: String {
        switch self {
        case .invalidLength:
            return MindsStrings.invalidLengthAlertErrorTitle()
        case .generic:
            return MindsStrings.genericErrorAlertTitle()
        }
    }

    var subtitle: String {
        switch self {
        case .invalidLength:
            return MindsStrings.invalidLengthAlertErrorSubtitle()
        case .generic:
            return MindsStrings.genericErrorAlertSubtitle()
        }
    }

    var primaryActionLabel: String {
        switch self {
        case .invalidLength:
            return ""
        case .generic:
            return MindsStrings.genericErrorAlertButtonLabel()
        }
    }

    var dismissButtonLabel: String {
        switch self {
        case .invalidLength:
            return MindsStrings.invalidLengthAlertErrorButtonLabel()
        case .generic:
            return MindsStrings.genericErrorAlertNeutralButtonLabel()
        }
    }
}

enum VoiceRecordState: Equatable {
    case initial, recording, loading, error(VoiceRecordErrorType)
    
    var isError: Binding<Bool> {
        switch self {
        case .error:
            return .constant(true)
        default:
            return .constant(false)
        }
    }

    static func == (lhs: VoiceRecordState, rhs: VoiceRecordState) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial), (.recording, .recording),
             (.loading, .loading), (.error, .error):
            return true
        default:
            return false
        }
    }
}

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
                    self.updateStateOnMainThread(to: .error(.generic))
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
}
