//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 12.04.2022.
//

import Foundation

public struct EnrollmentBody: Decodable {
    public var cpf: String
    public var externalId: String
    public var phoneNumber: String
    public var audios: [Audio]
}
