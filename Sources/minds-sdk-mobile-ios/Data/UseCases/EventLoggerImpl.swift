//
//  EventLoggerImpl.swift
//  
//
//  Created by Guilherme Domingues on 23/08/22.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore

final class EventLoggerImpl: EventLogger {

    static let shared = EventLoggerImpl()

    init() { }

    func logEvent(eventName: String, parameters: [String: Any]?) {
        Analytics.logEvent(eventName, parameters: parameters)
    }
}
