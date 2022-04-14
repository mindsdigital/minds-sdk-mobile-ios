//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation

public struct RecordingItem: Identifiable, Codable, Hashable {
    public init(key: String, value: String, recording: URL? = nil) {
        guard key.count > 0 && key.count <= 30 else {
            preconditionFailure("Invalid recording key length")
        }
        guard value.count >= 0 && value.count <= 300 else {
            preconditionFailure("Invalid recording value length")
        }
        self.key = key
        self.value = value
        self.recording = recording
    }
    
    public var id: String = UUID().uuidString
    public var key: String
    public var value: String
    public var recording: URL? = nil
}

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct Recording {
    public let fileURL: URL
    public let createdAt: Date
}
