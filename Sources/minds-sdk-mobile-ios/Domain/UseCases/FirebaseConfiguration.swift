//
//  FirebaseConfiguration.swift
//  
//
//  Created by Guilherme Domingues on 28/08/22.
//

import FirebaseAnalytics
import FirebaseCore

protocol FirebaseConfiguration {
    func configureFirebase()
}

extension FirebaseConfiguration {
    func configureFirebase() {
        let options: FirebaseOptions = FirebaseOptions(googleAppID: "1:876201019863:ios:24377202febafdc5e32392",
                                                       gcmSenderID: "876201019863")
        options.apiKey = "AIzaSyA8WygB3ziaJdxORNHVebHIHBJhiNbjFrc"
        options.projectID = "minds-sdk-xxas"
        options.clientID = "876201019863-rfqbj748916h775kdf83560nu3mo8t74.apps.googleusercontent.com"
        FirebaseApp.configure(options: options)
        _ = FeatureFlags.shared
    }
}
