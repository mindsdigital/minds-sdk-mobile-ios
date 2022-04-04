//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation

public struct RecordingItem: Identifiable, Codable, Hashable {
    public var id: String = UUID().uuidString
    public var key: String
    public var value: String
}
