//
//  Flags.swift
//  
//
//  Created by Guilherme Domingues on 28/08/22.
//

import Foundation

enum Flags: String {
    case errorText

    func defaultValue() -> NSObject {
        switch self {
        case .errorText: return NSString(string: "Erro genérico - Default")
        }
    }

    static func defaultDictionary() -> [String: NSObject] {
        return allValues()
            .reduce(into: [String: NSObject](), { $0["\($1.rawValue)"] = $1.defaultValue() })
    }

    private static func allValues() -> [Flags] {
        return [.errorText]
    }
}
