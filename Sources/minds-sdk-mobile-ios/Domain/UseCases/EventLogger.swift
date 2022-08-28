//
//  EventLogger.swift
//  
//
//  Created by Guilherme Domingues on 25/08/22.
//

import Foundation

protocol EventLogger: AnyObject {
    func logEvent(eventName: String, parameters: [String: Any]?)
}
