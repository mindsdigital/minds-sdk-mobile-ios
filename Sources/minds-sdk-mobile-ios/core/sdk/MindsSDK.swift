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

    public enum ProcessType {
        case enrollment, verification
    }
    
    @Published public var token: String = ""
    @Published public var cpf: String = ""
    @Published public var externalId: String = ""
    @Published public var phoneNumber: String = ""
    
    @Published public var sampleRate: Int = 16000
    @Published public var channelConfig: String = "" // todo: unused for now
    @Published public var linearPCMBitDepthKey: Int = 16
    @Published public var processType: ProcessType = .enrollment

    func setProcessType(processType: ProcessType) {
        self.processType = processType
    }

    func initializeSDK(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        validateAudioFormat { [weak self] validateAudioResult in
            switch validateAudioResult {
            case .success:
                self?.validateDataInput { dataInputResult in
                    switch dataInputResult {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func validateAudioFormat(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let request = ValidateFormatRequest(
            fileExtension: "wav",
            rate: sampleRate
        )

        SpeakerServices.init(networkRequest: NetworkManager())
            .validateAudioFormat(token: token, request: request) { result in
                switch result {
                case .success(let response):
                    if !response.isValid {
                        completion(.failure(.serverError))
                        assertionFailure("\(response.status ?? "") \(response.message)")
                    } else {
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    assertionFailure("Formato de aúdio inválido: \(request.fileExtension) \(request.rate) \(error.localizedDescription)")
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

        BiometricServices.init(networkRequest: NetworkManager())
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
