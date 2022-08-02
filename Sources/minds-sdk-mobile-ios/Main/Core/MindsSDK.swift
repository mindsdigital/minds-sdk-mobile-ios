//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 12.04.2022.
//

import Foundation
import UIKit
import SwiftUI

public class MindsSDK: ObservableObject {
    static public let shared = MindsSDK()
    
    public init() { }

    public enum ProcessType: String {
        case enrollment, verification
    }

    @Published public var token: String = ""

    @Published var cpf: String = ""
    @Published var externalId: String = ""
    @Published var phoneNumber: String = ""
    @Published var connectionTimeout: Float = 30.0
    @Published var processType: ProcessType = .enrollment
    @Published var liveness: RandomSentenceId = RandomSentenceId(id: 0)

    public func setProcessType(processType: ProcessType) {
        self.processType = processType
    }

    public func setCpf(_ cpf: String) {
        self.cpf = cpf
    }

    public func setExternalId(_ externalId: String) {
        self.externalId = externalId
    }

    public func setPhoneNumber(_ phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }

    public func setConnectionTimeout(_ connectionTimeout: Float) {
        self.connectionTimeout = connectionTimeout
    }

    func initializeSDK(completion: @escaping (Result<Void, Error>) -> Void) {
        self.validateDataInput { dataInputResult in
            switch dataInputResult {
            case .success:
                self.getRandomSentences { sentenceResult in
                    completion(sentenceResult)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getRandomSentences(completion: @escaping (Result<Void, Error>) -> Void) {
        LivenessService.init(networkRequest: NetworkManager(requestTimeout: 30))
            .getRandomSentence(token: token) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.liveness = RandomSentenceId(id: response.data.id, result: response.data.text)
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                    assertionFailure("Input de dados inválidos: \(error.localizedDescription)")
                }
            }
    }

    private func validateDataInput(completion: @escaping (Result<Void, Error>) -> Void) {
        let request = ValidateInputRequest(
            cpf: cpf,
            fileExtension: "ogg",
            checkForVerification: processType == .verification,
            phoneNumber: phoneNumber,
            rate: Constants.defaultSampleRate
        )

        BiometricServices.init(networkRequest: NetworkManager(requestTimeout: connectionTimeout))
            .validateInput(token: token, request: request) { result in
                switch result {
                case .success(let response):
                    if !response.success {
                        let error = DomainError(response.status, message: response.message)
                        completion(.failure(error))
                        assertionFailure("\(response.status) - \(response.message ?? "")")
                    } else {
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    assertionFailure("Input de dados inválidos: \(error.localizedDescription)")
                }
            }
    }

    public func initializeUIKitFlow(delegate: MindsSDKDelegate? = nil) -> UIViewController {
        let swiftUIView = MainView(voiceRecordingFlowActive: Binding(projectedValue: .constant(true)),
                                   delegate: delegate)
        let childView = UIHostingController(rootView: swiftUIView)
        childView.view.backgroundColor = .white
        return childView
    }
}
