//
//  SwiftUIView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct RecordingItemView: View {
    var audioURL: URL
    var displayRemoveButton: Bool
    var onDeleteAction: () -> Void = {}
    @ObservedObject var audioPlayer: AudioPlayer
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    
    public init(audioURL: URL,
                displayRemoveButton: Bool,
                onDeleteAction: @escaping () -> Void) {
        self.audioPlayer = AudioPlayer(audio: audioURL)
        self.audioURL = audioURL
        self.displayRemoveButton = displayRemoveButton
        self.onDeleteAction = onDeleteAction
    }
    
    public var body: some View {
        HStack {
            Button(action: {
                if audioPlayer.isPlaying {
                    self.audioPlayer.stopPlayback() // todo: change "stop" with pause
                } else {
                    self.audioPlayer.startPlayback(audio: self.audioURL) // todo: add another parameter for start time
                }
                
            }) {
                Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(uiConfigSdk.hexVariant400)
            }
            
            Slider(value: $audioPlayer.currentTime, in: 0...max(0, audioPlayer.audioPlayer.currentItem!.duration.seconds), onEditingChanged: { isEditing in
            })
                .accentColor(uiConfigSdk.hexVariant400)
            
            if (displayRemoveButton) {
                Button(action: {
                    onDeleteAction()
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(uiConfigSdk.hexVariant400)
                }
            }
        }
    }
}
