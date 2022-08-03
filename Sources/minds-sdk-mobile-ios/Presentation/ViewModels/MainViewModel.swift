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
    @Published var state: ViewState = .loading
    weak var delegate: MindsSDKDelegate?
    @Published var voiceRecordModel = VoiceRecordViewModel()
    
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
                    self.state = ViewState.loaded
                    self.voiceRecordModel.mindsDelegate = self.delegate
                }
            })
        }
    }
}
