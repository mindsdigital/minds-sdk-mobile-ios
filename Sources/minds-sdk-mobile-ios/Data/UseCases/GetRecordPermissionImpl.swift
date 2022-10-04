//
//  GetRecordPermissionImpl.swift
//  
//
//  Created by Guilherme Domingues on 28/09/22.
//

import Foundation
import AVFoundation

struct GetRecordPermissionImpl: GetRecordPermission {
    func execute() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            return true
        default:
            return false
        }
    }
}
