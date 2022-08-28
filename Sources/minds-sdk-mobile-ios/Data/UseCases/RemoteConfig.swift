//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 25/08/22.
//

import Foundation
import Firebase
import FirebaseRemoteConfig

final class FeatureFlags {
    
    var updatedValues: [String: NSObject]?

    func boolValueOrFalse(for flag: Flags) -> Bool {
        if let value = mostRecentvalue(for: flag) as? Bool {
            return value
        }
        return false
    }

    func boolValue(for flag: Flags) -> Bool? {
        if let value = mostRecentvalue(for: flag) as? Bool {
            return value
        }
        return nil
    }

    func intValue(for flag: Flags) -> Int? {
        if let value = mostRecentvalue(for: flag) as? Int {
            return value
        }
        return nil
    }

    func doubleValue(for flag: Flags) -> Double? {
        if let value = mostRecentvalue(for: flag) as? Double {
            return value
        }
        return nil
    }

    func stringValue(for flag: Flags) -> String? {
        if let value = mostRecentvalue(for: flag) as? NSString {
            return value as String
        }
        return nil
    }

    func jsonString(for flag: Flags) -> String? {
        if let value = mostRecentvalue(for: flag) as? NSDictionary {
            return String.dictToString(value)
        }
        return nil
    }

    func data(for flag: Flags) -> Data? {
        if let value = mostRecentvalue(for: flag) as? NSDictionary {
            return Data.dictToData(value)
        }
        return nil
    }

    func json(for flag: Flags) -> [String]? {
        if let value = mostRecentvalue(for: flag) as? [String] {
            return value
        }
        return nil
    }

    func intArrayOrEmpty(for flag: Flags) -> [Int] {
        guard let value = mostRecentvalue(for: flag) as? [Int] else {
            return []
        }
        return value
    }

    private func mostRecentvalue(for flag: Flags) -> NSObject {
        guard let updatedValues = updatedValues,
              let value = updatedValues[flag.rawValue] else {
                  return flag.defaultValue()
              }
        return value
    }

    static func defaultFFValues() -> [String: NSObject] {
        return Flags.defaultDictionnary()
    }

    static func requester() -> FeatureFlagRequester {
        let remote = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        settings.fetchTimeout = 10
        remote.configSettings = settings
        return remote
    }


    func requestFeatureFlagsInitialData(requester: FeatureFlagRequester, and defaultFFValues: [String: NSObject] ) {
        let featureFlagHelper = FeatureFlagHelper(requester: requester, defaultValues: defaultFFValues)
        featureFlagHelper.requestFeatureFlags { (ffs) in
            self.updatedValues = ffs
        }
    }
}

extension Data {

    static func dictToData(_ dict: NSDictionary) -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
            return nil
        }
        return data
    }
}

extension String {

    static func dictToString(_ dict: NSDictionary) -> String? {
        guard let data = Data.dictToData(dict) else {
            return nil
        }
        let json = String(decoding: data, as: UTF8.self)
        return json
    }

    static func fileToNSString(file: String, type: String = "json") -> NSString {
        if let filepath = Bundle.main.path(forResource: file, ofType: type),
           let jsonString = try? String(contentsOfFile: filepath) as NSString {
            return jsonString
        } else {
            return NSString()
        }
    }
}

enum Flags: String {
    case errorText

    func defaultValue() -> NSObject {
        switch self {
        case .errorText: return NSString(string: "Erro genérico - Default")
        }
    }

    static func defaultDictionnary() -> [String: NSObject] {
        return allValues()
             .reduce(into: [String: NSObject](), { $0["\($1.rawValue)"] = $1.defaultValue() })
    }

    private static func allValues() -> [Flags] {
        return [.errorText]
    }
}

public protocol FeatureFlagRequester {
    func fetchFeatureFlags(completion: @escaping (([String: NSObject]) -> Void))
    func setDefaults(_ defaultValues: [String: NSObject]?)
}

extension RemoteConfig: FeatureFlagRequester {}
let kFeatureFlagExpirationTime: Double = 3600

extension FeatureFlagRequester where Self: RemoteConfig {

    public func fetchFeatureFlags(completion: @escaping (([String: NSObject]) -> Void)) {
        self.fetch(withExpirationDuration: kFeatureFlagExpirationTime) { (_, _) in
            self.activate { _, _ in
                let featureFlags = self.allKeys(from: RemoteConfigSource.remote)
                let ffs = featureFlags
                    .reduce(into: [String: NSObject](), { $0["\($1)"] = self.configValue(forKey: $1)})
                completion(ffs)
            }
        }
    }
}

public protocol FeatureFlagProtocol {
    func requestFeatureFlags(completion: @escaping (([String: NSObject]) -> Void))
}

public struct FeatureFlagHelper: FeatureFlagProtocol {

    var requester: FeatureFlagRequester

    public init(requester: FeatureFlagRequester, defaultValues: [String: NSObject]) {
        self.requester = requester
        requester.setDefaults(defaultValues)
    }

    public func requestFeatureFlags(completion: @escaping (([String: NSObject]) -> Void)) {
        requester.fetchFeatureFlags(completion: completion)
    }
}
