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
    
    @Published var currentTime: TimeInterval = 0
    
    var audioPlayer: AVPlayer!
    var timeObserverToken: Any?
    
    func startPlayback (audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        audioPlayer.play()
        isPlaying = true
        
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)
        timeObserverToken = audioPlayer.addPeriodicTimeObserver(forInterval: time,
                                                                queue: .main) {
            [weak self] time in
            print("setting currentTime")
            self?.currentTime = time.seconds
            print("current seconds: ", time.seconds)
            print("current duration: ", self!.audioPlayer.currentItem!.duration.seconds)
            if (self!.currentTime > self!.audioPlayer.currentItem!.duration.seconds) {
                self?.stopPlayback()
                if let timeObserverToken = self?.timeObserverToken {
                    self?.audioPlayer.removeTimeObserver(timeObserverToken)
                    self?.timeObserverToken = nil
                }
            }
        }
    }
    
    func stopPlayback() {
        audioPlayer.pause()
        isPlaying = false
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
}

