//
//  SDKDataRepository.swift
//  
//
//  Created by Guilherme Domingues on 12/01/23.
//

import Foundation

struct SDKDataRepository {
    
    var document: String = ""
    var externalId: String? = ""
    var phoneNumber: String = ""
    var phoneCountryCode: Int? = nil
    var connectionTimeout: Float = 30.0
    var processType: MindsSDK.ProcessType = .enrollment
    var token: String = ""
    var liveness: RandomSentenceId = RandomSentenceId(id: 0)
    var externalCustomerId: String? = ""
    var showDetails: Bool = false
    var certification: Bool = false
    var insertOnQuarantine: Bool = false
    var environment: Environment? = nil
    var phrase: String? = nil
    var allowBackAction: Bool = false
    static var shared: SDKDataRepository = .init()

}
