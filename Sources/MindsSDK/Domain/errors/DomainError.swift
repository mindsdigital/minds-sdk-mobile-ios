//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 20/07/22.
//

import Foundation

public enum DomainError: Error, Equatable {
    case invalidDocument(String?)
    case invalidCPF(String?)
    case invalidPhoneNumber(String?)
    case invalidAudioFormat(String?)
    case customerNotFoundToPerformVerification(String?)
    case customerNotEnrolled(String?)
    case customerNotCertified(String?)
    case internalServerException
    case undefinedEnvironment
    case invalidToken
    case sentenceTooLongException

    init(_ serverResponse: String, message: String?) {
        switch serverResponse {
        case "invalid_document":
            self = DomainError.invalidDocument(message)
        case "invalid_cpf":
            self = DomainError.invalidCPF(message)
        case "invalid_phone_number":
            self = DomainError.invalidPhoneNumber(message)
        case "invalid_sample_rate":
            self = DomainError.invalidAudioFormat(message)
        case "customer_not_found_to_perform_verification":
            self = DomainError.customerNotFoundToPerformVerification(message)
        case "customer_not_enrolled":
            self = DomainError.customerNotEnrolled(message)
        case "customer_not_certified":
            self = DomainError.customerNotCertified(message)
        default:
            self = DomainError.internalServerException
        }
    }

    public static func ==(lhs: DomainError, rhs: DomainError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidDocument, .invalidDocument),
            (.invalidCPF, .invalidCPF),
            (.invalidPhoneNumber, .invalidPhoneNumber),
            (.invalidAudioFormat, .invalidAudioFormat),
            (.customerNotFoundToPerformVerification, .customerNotFoundToPerformVerification),
            (.customerNotEnrolled, .customerNotEnrolled),
            (.customerNotCertified, .customerNotCertified),
            (.internalServerException, .internalServerException),
            (.undefinedEnvironment, .undefinedEnvironment),
            (.invalidToken, .invalidToken),
            (.sentenceTooLongException, .sentenceTooLongException):
            return true
        default: return false
        }
    }

}
