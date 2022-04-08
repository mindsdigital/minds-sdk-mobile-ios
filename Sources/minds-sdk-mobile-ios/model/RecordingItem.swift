//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation

public struct RecordingItem: Identifiable, Codable, Hashable {
    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    
    public var id: String = UUID().uuidString
    public var key: String
    public var value: String
}

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct Recording {
    public let fileURL: URL
    public let createdAt: Date
}
