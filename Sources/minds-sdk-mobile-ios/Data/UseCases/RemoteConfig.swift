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

    static var shared: FeatureFlags = FeatureFlags()

    var updatedValues: [String: NSObject]?

    init() {
        fetchRemoteConfig()
    }

    // Mark: Fetching the flags
    private func fetchRemoteConfig() {
        let remote = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 1
        settings.fetchTimeout = 10
        remote.configSettings = settings
        remote.fetch(withExpirationDuration: 1) { (_, _) in
            remote.activate { _, _ in
                let featureFlags = remote.allKeys(from: RemoteConfigSource.remote)
                let ffs = featureFlags
                    .reduce(into: [String: NSObject](), { $0["\($1)"] = remote.configValue(forKey: $1)})
                self.updatedValues = self.parseFeatureFlags(ffs)
            }
        }
    }

    private func parseFeatureFlags(_ flags: [String: NSObject]) -> [String: NSObject] {
        var parsedFlags: [String: NSObject] = [:]
        parsedFlags = flags.reduce(into: [String: NSObject](), {

            if let json = ($1.value as? RemoteConfigValue)?.jsonValue as? NSObject {
                $0["\($1.key)"] = json
                return
            }

            if let string = ($1.value as? RemoteConfigValue)?.stringValue {

                if string == "true" {
                    $0["\($1.key)"] = NSNumber(value: true)
                    return
                }
                if string == "false" {
                    $0["\($1.key)"] = NSNumber(value: false)
                    return
                }

                 $0["\($1.key)"] = NSString(string: string)
                return
            }

            if let number = ($1.value as? RemoteConfigValue)?.numberValue {
                 $0["\($1.key)"] = number
                return
            }

        })

        return parsedFlags
    }

    private func mostRecentValue(for flag: Flags) -> NSObject {
        guard let updatedValues = updatedValues,
              let value = updatedValues[flag.rawValue] else {
                  return flag.defaultValue()
              }
        return value
    }

    func defaultFFValues() -> [String: NSObject] {
        return Flags.defaultDictionary()
    }

    // Mark: Accessing the flags
    func boolValueOrFalse(for flag: Flags) -> Bool {
        if let value = mostRecentValue(for: flag) as? Bool {
            return value
        }
        return false
    }

    func boolValue(for flag: Flags) -> Bool? {
        if let value = mostRecentValue(for: flag) as? Bool {
            return value
        }
        return nil
    }

    func intValue(for flag: Flags) -> Int? {
        if let value = mostRecentValue(for: flag) as? Int {
            return value
        }
        return nil
    }

    func doubleValue(for flag: Flags) -> Double? {
        if let value = mostRecentValue(for: flag) as? Double {
            return value
        }
        return nil
    }

    func stringValue(for flag: Flags) -> String? {
        if let value = mostRecentValue(for: flag) as? NSString {
            return value as String
        }
        return nil
    }

    func json(for flag: Flags) -> [String]? {
        if let value = mostRecentValue(for: flag) as? [String] {
            return value
        }
        return nil
    }

    func intArrayOrEmpty(for flag: Flags) -> [Int] {
        guard let value = mostRecentValue(for: flag) as? [Int] else {
            return []
        }
        return value
    }
}
