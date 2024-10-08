//
//  File.swift
//
//
//  Created by Guilherme Domingues on 05/01/23.
//

import Foundation
import UIKit
import Sentry

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
    
    public func setEnvironment(_ environment: Environment) {
        SDKDataRepository.shared.environment = environment
        EnvironmentManager.shared.setEnvironment(environment)
    }

    public func setExternalCustomerId(_ externalCustomerId: String?) {
        SDKDataRepository.shared.externalCustomerId = externalCustomerId
    }
    
    public func setShowDetails(_ showDetails: Bool) {
        SDKDataRepository.shared.showDetails = showDetails
    }
    
    public func setCertification(_ certification: Bool) {
        SDKDataRepository.shared.certification = certification
    }
    
    public func setInsertOnQuarantine(_ insertOnQuarantine: Bool) {
        SDKDataRepository.shared.insertOnQuarantine = insertOnQuarantine
    }
    
    public func setProcessType(_ processType: ProcessType) {
        SDKDataRepository.shared.processType = processType
    }

    public func setDocument(_ document: String) {
        SDKDataRepository.shared.document = document
    }

    public func setExternalId(_ externalId: String?) {
        SDKDataRepository.shared.externalId = externalId
    }

    public func setPhoneNumber(_ phoneNumber: String) {
        SDKDataRepository.shared.phoneNumber = phoneNumber
    }
    
    public func setPhoneCountryCode(_ phoneCountryCode: Int) {
        SDKDataRepository.shared.phoneCountryCode = phoneCountryCode
    }

    public func setConnectionTimeout(_ connectionTimeout: Float) {
        SDKDataRepository.shared.connectionTimeout = connectionTimeout
    }
    
    public func setUserVerbalizationPhrase(_ phrase: String) {
        SDKDataRepository.shared.phrase = phrase
    }
    
    public func setAllowBackAction(_ allowBackAction: Bool) {
        SDKDataRepository.shared.allowBackAction = allowBackAction
    }

    public func initialize(on navigationController: UINavigationController, onReceive: @escaping ((Error?) -> Void)) {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            mainCoordinator = .init(navigationController: navigationController)

            verifyMicrophonePermission { [weak self] in
                guard let self = self else { return }

                do {
                    try self.initializeSDK { result in
                        switch result {
                        case .success(let response):
                            SDKDataRepository.shared.liveness = response
                            self.mainCoordinator?.showVoiceRecordView(delegate: self.delegate)
                        case .failure(let error):
                            onReceive(error)
                        }
                    }
                } catch {
                    onReceive(error)
                }
            }
        }

    private func initializeSDK(completion: @escaping (Result<RandomSentenceId, Error>) -> Void) throws {
        
        if(SDKDataRepository.shared.environment == nil) {
            throw DomainError.undefinedEnvironment
        }
        
        if(SDKDataRepository.shared.phrase != nil && !SDKDataRepository.shared.phrase!.isEmpty && SDKDataRepository.shared.phrase!.count > 300) {
            throw DomainError.sentenceTooLongException
        }

        guard !SDKDataRepository.shared.token.isEmpty else {
            throw DomainError.invalidToken
        }
        
        initializeSentry { result in
            switch result {
            case .success:
                debugPrint("Sentry initialized successfully.")
            case .failure(_):
                debugPrint("Failed to initialize Sentry")
            }
        }
        
        self.validateDataInput { [weak self] dataInputResult in
            switch dataInputResult {
            case .success:
                if SDKDataRepository.shared.phrase == nil {
                    self?.getRandomSentences { sentenceResult in
                        completion(sentenceResult)
                    }
                } else {
                    completion(.success(RandomSentenceId(id: 0, result: "")))
                }
            case .failure(let error):
                SentrySDK.capture(error: error)
                completion(.failure(error))
            }
        }
    }
    
    
    private func initializeSentry(completion: @escaping (Result<Void?, Error>) -> Void) {
        VoiceApiServices.init(networkRequest: NetworkManager(requestTimeout: SDKDataRepository.shared.connectionTimeout))
            .getDsn(token: SDKDataRepository.shared.token) { result in
                switch result {
                case .success(let response):
                    if response.success && !(response.data.isEmpty) {
                        SentrySDK.start { options in
                            options.dsn = response.data
                            options.environment = EnvironmentManager.shared.getCurrentEnvironment().rawValue
                        }
                    }
                    do {
                        let decodedToken = try decode(jwtToken: SDKDataRepository.shared.token)
                        SentrySDK.configureScope { scope in
                            scope.setTag(value: String(decodedToken["company_id"] as! Int), key: "company_id")
                        }
                    } catch {
                        debugPrint("Error decoding JWT: \(error)")
                    }
                    completion(.success(nil))
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
                    SentrySDK.capture(error: error)
                    completion(.failure(error))
                }
            }
    }

    private func validateDataInput(completion: @escaping (Result<Void, Error>) -> Void) {
        let request = ValidateInputRequest(
            document: Document(value: SDKDataRepository.shared.document),
            checkForVerification: SDKDataRepository.shared.processType == .authentication,
            phoneNumber: SDKDataRepository.shared.phoneNumber,
            phoneCountryCode: SDKDataRepository.shared.phoneCountryCode,
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
                    SentrySDK.capture(error: error)
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
