//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 05/01/23.
//

import Foundation
import SwiftUI
import UIKit
//
//public final class MindsSDKInitializer {
//    
//    weak var delegate: MindsSDKDelegate?
//    private var navigationController: UINavigationController?
//    private let sdk: MindsSDK
//    
//    public init(sdk: MindsSDK = MindsSDK.shared) {
//        self.sdk = sdk
//    }
//
//    public func initialize(onReceive: @escaping ((Error?) -> Void)) {
//        sdk.initializeSDK { result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async { [weak self] in
//                    self?.sdk.liveness = response
//                }
//            case .failure(let error):
//                onReceive(error)
//            }
//        }
//    }
//
//    public func initialize(on navigationController: UINavigationController?,
//                           delegate: MindsSDKDelegate? = nil,
//                           onReceive: @escaping ((Error?) -> Void)) {
//        self.navigationController = navigationController
//        self.delegate = delegate
//        
//        verifyMicrophonePermission {
//            self.sdk.initializeSDK { result in
//                switch result {
//                case .success(let response):
//                    print("---> response: \(response)")
////                    DispatchQueue.main.async {
////                        let hostingController = self.createUIHostingController(delegate, response)
////                        self.sdk.liveness = response
////                        self.navigationController?.pushViewController(hostingController, animated: true)
////                    }
//                case .failure(let error):
//                    onReceive(error)
//                }
//            }
//        }
//    }
//
//
//}
//
//
//class MainViewModel {
//    var sdk = MindsSDK.shared
//    var state: ViewState = .loading
//    weak var delegate: MindsSDKDelegate?
////    var voiceRecordModel = VoiceRecordViewModel(voiceRecordingFlowActive: .constant(false))
//    
//    enum ViewState {
//        case loaded
//        case loading
//    }
//
//    func loadData() {
//        sdk.initializeSDK { result in
//            print("--> result: \(result)")
//        }
//    }
//}
