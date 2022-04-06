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
    @State var isPlaying: Bool = false
    @State var duration: Float = 20
    @State var currentTime: Float = 0
    var onDeleteAction: () -> Void = {}
    
    public init(onDeleteAction: @escaping () -> Void) {
        self.onDeleteAction = onDeleteAction
    }
    
    public var body: some View {
        HStack {
            Button(action: {
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            }
            
            Slider(value: $currentTime, in: 0...duration, onEditingChanged: { isEditing in
            })
            
            Button(action: {
                onDeleteAction()
            }) {
                Image(systemName: "trash.fill")
            }
        }
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
struct RecordingItemView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingItemView(onDeleteAction: {
            
        })
    }
}
