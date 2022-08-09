//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI


public class MindsSDKInitializer {
    private var sdk = MindsSDK.shared
    @Binding var voiceRecordingFlowActive: Bool
    
    public init(voiceRecordingFlowActive: Binding<Bool>) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
    }

    public func initialize(onReceive: @escaping ((Error?) -> Void)) {
        sdk.initializeSDK { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.sdk.liveness = response
                    self.voiceRecordingFlowActive = true
                }
            case .failure(let error):
                onReceive(error)
            }
        }
    }
}


class MainViewModel: ObservableObject {
    @ObservedObject var sdk = MindsSDK.shared
    @Published var state: ViewState = .loading
    weak var delegate: MindsSDKDelegate?
    @Published var voiceRecordModel = VoiceRecordViewModel(voiceRecordingFlowActive: .constant(false))
    
    enum ViewState {
        case loaded
        case loading
    }

    func loadData() {
        sdk.initializeSDK { result in
            _ = result.publisher.sink(receiveCompletion: { _ in
            }, receiveValue: { value in
                DispatchQueue.main.async {
                    self.state = ViewState.loaded
                    self.voiceRecordModel.mindsDelegate = self.delegate
                }
            })
        }
    }
}
