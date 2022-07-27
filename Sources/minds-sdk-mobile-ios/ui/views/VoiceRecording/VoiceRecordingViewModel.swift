//
//  VoiceRecordingViewModel.swift
//  
//
//  Created by Guilherme Domingues on 26/07/22.
//

import SwiftUI

class VoiceRecordingViewModel: ObservableObject {
    var uiConfigSdk = MindsSDKUIConfig.shared
    @Published var livenessText: String = ""
    @State private var serviceDelegate: VoiceRecordingServiceDelegate
    weak var mindsDelegate: MindsSDKDelegate?

    init(serviceDelegate: VoiceRecordingServiceDelegate = VoiceRecordingServiceDelegateImpl()) {
        self.serviceDelegate = serviceDelegate
    }

    func updateLivenessText(using item: RecordingItem) {
        self.livenessText = item.value
    }

    func onLongPress() {
        serviceDelegate.startRecording()
    }

    func onTap() {
        print("onTap")
    }

    func onRelease() {
        serviceDelegate.stopRecording()
        DispatchQueue.main.async {
            self.serviceDelegate.sendAudio { result in
                switch result {
                case .success(let response):
                    if response.success {
                        self.mindsDelegate?.onSuccess(response)
                    } else {
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
                }
            }
        }
    }
}
