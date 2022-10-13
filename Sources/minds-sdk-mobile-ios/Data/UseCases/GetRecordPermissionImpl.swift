//
//  GetRecordPermissionImpl.swift
//  
//
//  Created by Guilherme Domingues on 28/09/22.
//

import Foundation
import AVFoundation

struct GetRecordPermissionImpl: GetRecordPermission {
    func execute() -> AVAudioSession.RecordPermission {
        return AVAudioSession.sharedInstance().recordPermission
    }
}
