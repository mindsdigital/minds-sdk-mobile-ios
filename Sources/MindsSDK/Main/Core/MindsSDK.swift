//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 05/01/23.
//

import Foundation
import UIKit

public class MindsSDK {

    public enum ProcessType: String {
        case enrollment, authentication
    }

    private var delegate: MindsSDKDelegate?

    private var mainCoordinator: MainCoordinator?
    
    public init(delegate: MindsSDKDelegate) {
        self.delegate = delegate
    }

    public func setToken(_ token: String) {
        SDKDataRepository.shared.token = token
    }

    public func setExternalCustomerId(_ externalCustomerId: String?) {
        SDKDataRepository.shared.externalCustomerId = externalCustomerId
    }
    
    public func setShowDetails(_ showDetails: Bool) {
        SDKDataRepository.shared.showDetails = showDetails
    }
    
    public func setProcessType(_ processType: ProcessType) {
        SDKDataRepository.shared.processType = processType
    }

    public func setCpf(_ cpf: String) {
        SDKDataRepository.shared.cpf = cpf
    }

    public func setExternalId(_ externalId: String?) {
        SDKDataRepository.shared.externalId = externalId
    }

    public func setPhoneNumber(_ phoneNumber: String) {
        SDKDataRepository.shared.phoneNumber = phoneNumber
    }

    public func setConnectionTimeout(_ connectionTimeout: Float) {
        SDKDataRepository.shared.connectionTimeout = connectionTimeout
    }

    public func initialize(on navigationController: UINavigationController, onReceive: @escaping ((Error?) -> Void)) {
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        mainCoordinator = .init(navigationController: navigationController)

        verifyMicrophonePermission { [weak self] in
            guard let self = self else { return }

            self.initializeSDK { result in
                switch result {
                case .success(let response):
                    SDKDataRepository.shared.liveness = response
                    self.mainCoordinator?.showVoiceRecordView(delegate: self.delegate)
                case .failure(let error):
                    onReceive(error)
                }
            }
        }
    }

    private func initializeSDK(completion: @escaping (Result<RandomSentenceId, Error>) -> Void) {
        validateDataInput { [weak self] dataInputResult in
            switch dataInputResult {
            case .success:
                self?.getRandomSentences { sentenceResult in
                    completion(sentenceResult)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func getRandomSentences(completion: @escaping (Result<RandomSentenceId, Error>) -> Void) {
        LivenessService.init(networkRequest: NetworkManager(requestTimeout: 30))
            .getRandomSentence(token: SDKDataRepository.shared.token) { result in
                switch result {
                case .success(let response):
                    completion(.success(RandomSentenceId(id: response.data.id, result: response.data.text)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    private func validateDataInput(completion: @escaping (Result<Void, Error>) -> Void) {
        let request = ValidateInputRequest(
            cpf: SDKDataRepository.shared.cpf,
            fileExtension: "ogg",
            checkForVerification: SDKDataRepository.shared.processType == .authentication,
            phoneNumber: SDKDataRepository.shared.phoneNumber,
            rate: Constants.defaultSampleRate
        )

        BiometricServices.init(networkRequest: NetworkManager(requestTimeout: SDKDataRepository.shared.connectionTimeout))
            .validateInput(token: SDKDataRepository.shared.token, request: request) { result in
                switch result {
                case .success(let response):
                    if !response.success {
                        let error = DomainError(response.status, message: response.message)
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    private func verifyMicrophonePermission(_ completion: (() -> Void)? = nil) {
        let audioPermission: GetRecordPermission = GetRecordPermissionImpl()
        switch audioPermission.execute() {
        case .denied:
            delegate?.microphonePermissionNotGranted()
        case .undetermined:
            delegate?.showMicrophonePermissionPrompt()
        default:
            completion?()
        }
    }

}
