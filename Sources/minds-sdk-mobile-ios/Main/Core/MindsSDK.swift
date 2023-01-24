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

    public var token: String = "" {
        didSet {
            SDKDataRepository.shared.token = token
        }
    }

    public weak var delegate: MindsSDKDelegate?

    private var navigationController: UINavigationController?
    
    public init(cpf: String, externalId: String, phoneNumber: String, connectionTimeout: Float = 30.0, processType: ProcessType) {
        SDKDataRepository.shared.cpf = cpf
        SDKDataRepository.shared.externalId = externalId
        SDKDataRepository.shared.phoneNumber = phoneNumber
        SDKDataRepository.shared.connectionTimeout = connectionTimeout
        SDKDataRepository.shared.processType = processType
        SDKDataRepository.shared.token = token
    }

    public func setExternalCustomerId(externalCustomerId: String) {
        SDKDataRepository.shared.externalCustomerId = externalCustomerId
    }
    
    public func setShowDetails(showDetails: Bool) {
        SDKDataRepository.shared.showDetails = showDetails
    }
    
    public func setProcessType(processType: ProcessType) {
        SDKDataRepository.shared.processType = processType
    }

    public func setCpf(_ cpf: String) {
        SDKDataRepository.shared.cpf = cpf
    }

    public func setExternalId(_ externalId: String) {
        SDKDataRepository.shared.externalId = externalId
    }

    public func setPhoneNumber(_ phoneNumber: String) {
        SDKDataRepository.shared.phoneNumber = phoneNumber
    }

    public func setConnectionTimeout(_ connectionTimeout: Float) {
        SDKDataRepository.shared.connectionTimeout = connectionTimeout
    }

    public func initialize(on navigationController: UINavigationController?, onReceive: @escaping ((Error?) -> Void)) {
        self.navigationController = navigationController

        verifyMicrophonePermission { [weak self] in
            self?.initializeSDK { result in
                switch result {
                case .success(let response):
                    guard let self = self else { return }
                    SDKDataRepository.shared.liveness = response

                    DispatchQueue.main.async {
                        let hostingController: UIViewController = self.createHostingController()
                        self.navigationController?.pushViewController(hostingController, animated: true)
                    }
                case .failure(let error):
                    onReceive(error)
                }
            }
        }
    }

    private func createHostingController() -> UIViewController {
        let viewModel: VoiceRecordViewModel = .init(livenessText: SDKDataRepository.shared.liveness)
        viewModel.mindsDelegate = delegate
        viewModel.delegate = self
        let viewController: VoiceRecordViewController = .init(viewModel: viewModel)

        return viewController
    }

    private func initializeSDK(completion: @escaping (Result<RandomSentenceId, Error>) -> Void) {
        validateDataInput { dataInputResult in
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

    private func getRandomSentences(completion: @escaping (Result<RandomSentenceId, Error>) -> Void) {
        LivenessService.init(networkRequest: NetworkManager(requestTimeout: 30))
            .getRandomSentence(token: token) { result in
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

extension MindsSDK: VoiceRecordViewModelDelegate {

    func closeFlow() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
