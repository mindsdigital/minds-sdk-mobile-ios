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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.serviceDelegate.sendAudio()
        }
    }
}
