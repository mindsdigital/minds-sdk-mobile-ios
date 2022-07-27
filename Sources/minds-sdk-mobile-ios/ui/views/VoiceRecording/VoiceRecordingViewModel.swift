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

    func updateLivenessText(using item: RecordingItem) {
        self.livenessText = item.value
    }

    func onLongPress() {
        print("onLongPress")
    }

    func onTap() {
        print("onTap")
    }

    func onRelease() {
        print("onRelease")
    }
}
