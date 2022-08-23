//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 23/08/22.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore

final class EventLogger {

    static let shared = EventLogger()

    init() {
        let options: FirebaseOptions = FirebaseOptions(googleAppID: "1:876201019863:ios:24377202febafdc5e32392",
                                                       gcmSenderID: "876201019863")
        options.apiKey = "AIzaSyA8WygB3ziaJdxORNHVebHIHBJhiNbjFrc"
        options.projectID = "minds-sdk-xxas"
        options.clientID = "876201019863-rfqbj748916h775kdf83560nu3mo8t74.apps.googleusercontent.com"
        FirebaseApp.configure(options: options)
        FirebaseConfiguration.shared.setLoggerLevel(.min)
    }

    func testLog() {
        Analytics.logEvent("test_21", parameters: ["param": 1])
    }
}
