//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 20/07/22.
//

import Foundation

public enum MindsSDKError: Error, Equatable {
    case invalidCPF(String?)
    case invalidPhoneNumber(String?)
    case invalidAudioFormat(String?)
    case customerNotFoundToPerformVerification(String?)
    case customerNotEnrolled(String?)
    case customerNotCertified(String?)
    case internalServerException

    public init(_ serverResponse: String, message: String?) {
        switch serverResponse {
        case "invalid_cpf":
            self = MindsSDKError.invalidCPF(message)
        case "invalid_phone_number":
            self = MindsSDKError.invalidPhoneNumber(message)
        case "invalid_sample_rate":
            self = MindsSDKError.invalidAudioFormat(message)
        case "customer_not_found_to_perform_verification":
            self = MindsSDKError.customerNotFoundToPerformVerification(message)
        case "customer_not_enrolled":
            self = MindsSDKError.customerNotEnrolled(message)
        case "customer_not_certified":
            self = MindsSDKError.invalidAudioFormat(message)
        default:
            self = MindsSDKError.internalServerException
        }
    }

    public static func ==(lhs: MindsSDKError, rhs: MindsSDKError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidCPF, .invalidCPF),
                (.invalidPhoneNumber, .invalidPhoneNumber),
            (.invalidAudioFormat, .invalidAudioFormat),
            (.customerNotFoundToPerformVerification, .customerNotFoundToPerformVerification),
            (.customerNotEnrolled, .customerNotEnrolled),
            (.customerNotCertified, .customerNotCertified),
            (.internalServerException, .internalServerException):
            return true
        default: return false
        }
    }

}
