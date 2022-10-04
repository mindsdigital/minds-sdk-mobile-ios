//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI
import UIKit

public class MindsSDKInitializer {
    private var sdk = MindsSDK.shared
    @Binding var voiceRecordingFlowActive: Bool
    weak var delegate: MindsSDKDelegate?
    
    public init(voiceRecordingFlowActive: Binding<Bool>) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
    }

    public convenience init() {
        self.init(voiceRecordingFlowActive: .constant(true))
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

    private var navigationController: UINavigationController?

    public func initialize(on navigationController: UINavigationController?,
                           delegate: MindsSDKDelegate? = nil,
                           onReceive: @escaping ((Error?) -> Void)) {
        self.navigationController = navigationController
        self.delegate = delegate

        verifyMicrophonePermission {
            self.sdk.initializeSDK { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        let hostingController = self.createUIHostingController(delegate, response)
                        self.sdk.liveness = response
                        self.navigationController?.pushViewController(hostingController, animated: true)
                    }
                case .failure(let error):
                    onReceive(error)
                }
            }
        }
    }

    func verifyMicrophonePermission(_ completion: (() -> Void)? = nil) {
        let audioPermission: GetRecordPermission = GetRecordPermissionImpl()
        switch audioPermission.execute() {
        case .denied:
            showMicPermissionNotGrantedScreen()
        case .undetermined:
            delegate?.showMicrophonePermissionPrompt { granted in
                if granted {
                    DispatchQueue.main.async {
                        completion?()
                    }
                } else {
                    self.showMicPermissionNotGrantedScreen()
                }
            }
        default:
            completion?()
        }
    }

    private func showMicPermissionNotGrantedScreen() {
        let micView: MicrophonePermissionView = MicrophonePermissionView(askLater: askMicPermissionLater,
                                                                         showPrompt: showMicPermissionPrompt)
    }

    private func askMicPermissionLater() {
        
    }

    private func showMicPermissionPrompt() {
        
    }

    private func createUIHostingController(_ delegate: MindsSDKDelegate?,
                                           _ response: RandomSentenceId) -> UIViewController {
        let swiftUIView = VoiceRecordView(delegate: delegate,
                                          voiceRecordingFlowActive: .constant(true),
                                          completion: popToRootViewController)
        swiftUIView.viewModel.updateLivenessText(response)
        return UIHostingController(rootView: swiftUIView)
    }

    private func popToRootViewController() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
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
