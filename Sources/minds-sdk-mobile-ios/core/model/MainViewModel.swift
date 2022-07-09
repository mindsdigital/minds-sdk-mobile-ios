//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
class MainViewModel: ObservableObject {
    @ObservedObject var sdk = MindsSDK.shared
    @ObservedObject var config = MindsSDKUIConfig.shared
    @Published var state: ViewState = .loading

    enum ViewState {
        case loaded(Bool)
        case loading
    }

    func loadData() {
        sdk.initializeSDK { result in
            _ = result.publisher.sink(receiveCompletion: { received in
                print(received)
            }, receiveValue: { value in
                DispatchQueue.main.async {
                    self.state = ViewState.loaded(self.config.showOnboard())
                    print(self.state)
                }
            })
        }
    }
}
