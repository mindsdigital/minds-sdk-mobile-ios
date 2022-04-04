//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation

struct RecordingItem: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var key: String
    var value: String
}
