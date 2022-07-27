//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @ObservedObject var sdk = MindsSDK.shared
    @ObservedObject var config = MindsSDKUIConfig.shared
    @Published var state: ViewState = .loading
    @Published var voiceRecordModel = VoiceRecordingViewModel()
    weak var delegate: MindsSDKDelegate?

    init(delegate: MindsSDKDelegate?) {
        self.delegate = delegate
    }

    enum ViewState {
        case loaded
        case loading
    }

    func loadData() {
        sdk.initializeSDK { result in
            _ = result.publisher.sink(receiveCompletion: { received in
                print(received)
            }, receiveValue: { value in
                DispatchQueue.main.async {
                    guard let recordItem = self.sdk.recordItem else {
                        self.state = .loading
                        return
                    }
                    self.state = ViewState.loaded
                    self.voiceRecordModel.updateLivenessText(using: recordItem)
                    self.voiceRecordModel.mindsDelegate = self.delegate
                }
            })
        }
    }
}
