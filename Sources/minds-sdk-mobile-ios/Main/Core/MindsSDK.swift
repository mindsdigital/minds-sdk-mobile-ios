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
        case enrollment, verification
    }

    public var token: String = ""
    public weak var delegate: MindsSDKDelegate?

    var cpf: String = ""
    var externalId: String = ""
    var phoneNumber: String = ""
    var connectionTimeout: Float = 30.0
    var processType: ProcessType = .enrollment
    var liveness: RandomSentenceId = RandomSentenceId(id: 0)
    
    private var navigationController: UINavigationController?
    
    public init(cpf: String, externalId: String, phoneNumber: String, connectionTimeout: Float = 30.0, processType: ProcessType) {
        self.cpf = cpf
        self.externalId = externalId
        self.phoneNumber = phoneNumber
        self.connectionTimeout = connectionTimeout
        self.processType = processType
    }

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

    public func initialize(on navigationController: UINavigationController?, onReceive: @escaping ((Error?) -> Void)) {
        self.navigationController = navigationController

        verifyMicrophonePermission { [weak self] in
            self?.initializeSDK { result in
                switch result {
                case .success(let response):
                    guard let self = self else { return }
                    self.liveness = response

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
        let viewModel: VoiceRecordViewModel = .init(mindsSDK: self, livenessText: liveness)
        viewModel.mindsDelegate = delegate
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
