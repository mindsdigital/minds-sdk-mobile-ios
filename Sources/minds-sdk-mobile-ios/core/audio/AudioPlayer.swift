//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 07.04.2022.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

@available(macOS 11, *)
@available(iOS 14.0, *)
public class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    public let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    public init(audio: URL) {
        super.init()
        audioPlayer = AVPlayer(url: audio)
    }
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    @Published var currentTime: TimeInterval = 0.0
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var audioPlayer: AVPlayer!
    var timeObserverToken: Any?
    
    func changeSliderValue(_ timeInterval: TimeInterval) {
        audioPlayer.pause()
        isPlaying = false
        currentTime = timeInterval
    }
    
    func startPlayback (audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        audioPlayer.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1000000))
        audioPlayer.play()
        isPlaying = true
    }
    
    func pausePlayback() {
        audioPlayer.pause()
        isPlaying = false
        currentTime = Double(CMTimeGetSeconds(audioPlayer.currentTime()))
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
}

