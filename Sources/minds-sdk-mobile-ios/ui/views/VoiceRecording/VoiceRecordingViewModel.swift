//
//  VoiceRecordingViewModel.swift
//  
//
//  Created by Guilherme Domingues on 26/07/22.
//

import SwiftUI

enum VoiceRecordingViewState {
    case idle, recording, sending, error
}

class VoiceRecordingViewModel: ObservableObject {
    var uiConfigSdk = MindsSDKUIConfig.shared
    private var serviceDelegate: VoiceRecordingServiceDelegate
    weak var mindsDelegate: MindsSDKDelegate?

    @Published var livenessText: String = ""
    @Published var state: VoiceRecordingViewState = .idle

    init(serviceDelegate: VoiceRecordingServiceDelegate = VoiceRecordingServiceDelegateImpl()) {
        self.serviceDelegate = serviceDelegate
    }

    func updateLivenessText(using item: RecordingItem) {
        self.livenessText = item.value
    }

    func doBiometricsLater() {
        
    }

    func onLongPress() {
        serviceDelegate.startRecording()
        updateStateOnMainThread(to: .recording)
    }

    func onTap() {
        print("onTap")
    }

    func onRelease() {
        serviceDelegate.stopRecording()
        updateStateOnMainThread(to: .sending)

        DispatchQueue.main.async {
            self.serviceDelegate.sendAudio { result in
                switch result {
                case .success(let response):
                    if response.success {
                        self.mindsDelegate?.onSuccess(response)
                        self.updateStateOnMainThread(to: .idle)
                    } else {
                        self.updateStateOnMainThread(to: .error)

                        guard response.status != "invalid_length" else {
                            print("invalid_length")
                            return
                        }

                        let biometric = BiometricResponse(id: response.id,
                                                          status: response.status,
                                                          success: false)
                        self.mindsDelegate?.onServiceError(biometric)
                    }
                case .failure(let error):
                    self.mindsDelegate?.onNetworkError(error)
                    self.updateStateOnMainThread(to: .error)
                }
            }
        }
    }

    private func updateStateOnMainThread(to newState: VoiceRecordingViewState) {
        DispatchQueue.main.async {
            self.state = newState
        }
    }
}
