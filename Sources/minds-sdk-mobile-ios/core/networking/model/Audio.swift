//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 12.04.2022.
//

import Foundation

public struct Audio: Decodable {
    public var theExtension: String? // "extension" is a keywork, it cannot be used
    public var content: String
    public var rate: String
}
