//
//  SDKDataRepository.swift
//  
//
//  Created by Guilherme Domingues on 12/01/23.
//

import Foundation

struct SDKDataRepository {
    
    var cpf: String = ""
    var externalId: String = ""
    var phoneNumber: String = ""
    var connectionTimeout: Float = 30.0
    var processType: MindsSDK.ProcessType = .enrollment
    var token: String = ""
    var liveness: RandomSentenceId = RandomSentenceId(id: 0)
    
    static var shared: SDKDataRepository = .init()

}
