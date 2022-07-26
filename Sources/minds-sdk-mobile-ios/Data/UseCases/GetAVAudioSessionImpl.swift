//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation
import AVFoundation

struct GetAVAudioSessionImpl : GetAVAudioSession {
    func execute() throws -> AVAudioSession {
        let avAudioSession = AVAudioSession.sharedInstance()
        try avAudioSession.setCategory(.playAndRecord, mode: .default)
        try avAudioSession.setActive(true)
        return avAudioSession
    }
}
