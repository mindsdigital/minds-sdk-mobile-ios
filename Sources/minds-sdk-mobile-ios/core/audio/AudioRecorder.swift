//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 07.04.2022.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

@available(macOS 11, *)
@available(iOS 15.0, *)
class AudioRecorder: NSObject, ObservableObject {
    
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @ObservedObject var sdk = MindsSDK.shared
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    @Published var recordingsCount: Int = 0

    var sampleRate: Int = 48000
    
    override init() {
        recordingsCount = 0
    }
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording(key: String) {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.temporaryDirectory
        let audioFilename = documentPath.appendingPathComponent("\(key).wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: self.sampleRate,
            AVNumberOfChannelsKey: 1,
//            AVLinearPCMBitDepthKey: sdk.linearPCMBitDepthKey,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
    }
    
    //    func fetchRecording(key: String) -> URL {
    //        let fileManager = FileManager.default
    //        let documentDirectory = fileManager.temporaryDirectory
    //        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
    //        for audio in directoryContents {
    //            let recording = Recording(fileURL: audio, createdAt: getCreationDate(for: audio))
    //            recordings.append(recording)
    //        }
    //
    //        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
    //
    //        objectWillChange.send(self)
    //    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
                try FileManager.default.removeItem(at: url)
                recordingsCount -= 1
            } catch {
                print("File could not be deleted!")
            }
        }
    }
    
}
