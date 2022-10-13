//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 28/09/22.
//

import Foundation
import AVFoundation

protocol GetRecordPermission {
    func execute() -> AVAudioSession.RecordPermission
}
