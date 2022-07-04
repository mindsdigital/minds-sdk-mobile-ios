//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 12.04.2022.
//

import Foundation

@available(macOS 11, *)
@available(iOS 14.0, *)
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
    @Published var connectionTimeout: Float = 20.0
    
    @Published var sampleRate: Int = 22050
    @Published public var linearPCMBitDepthKey: Int = 16
    @Published public var processType: ProcessType = .enrollment

    @Published var recordItem: RecordingItem? {
        didSet {
            guard let recordItem = recordItem else {
                return
            }

            DispatchQueue.main.async {
                MindsSDKUIMessages.shared.recordingItems = [recordItem]
            }
        }
    }

    public var onBiometricsReceive: ((Result<BiometricResponse, NetworkError>) -> Void)?

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

    public func initializeSDK(completion: @escaping (Result<Void, Error>) -> Void) {
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
                        self.recordItem = RecordingItem(key: String(response.data.id),
                                                        value: response.data.text,
                                                        recording: nil)
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                    assertionFailure("Input de dados inválidos: \(error.localizedDescription)")
                }
            }
    }

    private func validateDataInput(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let request = ValidateInputRequest(
            cpf: cpf,
            fileExtension: "wav",
            checkForVerification: processType == .verification,
            phoneNumber: phoneNumber,
            rate: sampleRate
        )

        BiometricServices.init(networkRequest: NetworkManager(requestTimeout: connectionTimeout))
            .validateInput(token: token, request: request) { result in
                switch result {
                case .success(let response):
                    if !response.success  {
                        completion(.failure(.serverError))
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
}
