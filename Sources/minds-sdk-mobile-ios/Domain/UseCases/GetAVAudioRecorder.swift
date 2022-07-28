//
//  File.swift
//  
//
//  Created by Divino Borges on 25/07/22.
//

import Foundation
import AVFoundation

protocol GetAVAudioRecorder {
    func execute() throws -> AVAudioRecorder
}
