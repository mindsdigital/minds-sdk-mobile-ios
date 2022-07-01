//
//  RecordingButton.swift
//  
//
//  Created by Guilherme Domingues on 22/06/22.
//

import SwiftUI

struct RecordingButton: View {
    @State private var isAnimating: Bool = false

    private var isRecording: Bool
    private var backgroundColor: Color
    private var recordingButtonHandler: (() -> Void)?
    private var stopButtonHandler: (() -> Void)?

    init(isRecording: Bool, background: Color,
         recordingButtonHandler: (() -> Void)? = nil,
         stopButtonHandler: (() -> Void)? = nil) {
        self.isRecording = isRecording
        self.backgroundColor = background
        self.recordingButtonHandler = recordingButtonHandler
        self.stopButtonHandler = stopButtonHandler
    }

    var body: some View {
        if isRecording {
            Button(action: {
                recordingButtonHandler?()
            }) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color.white)
            }
            .frame(width: 56, height: 56)
            .background(animationStack)
            .onAppear {
                DispatchQueue.main.async {
                    self.isAnimating = true
                }
            }
        } else {
            Button(action: {
                stopButtonHandler?()
            }) {
                Image(uiImage: UIImage(named: "voice", in: .module, with: nil)!)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(backgroundColor)
            }
            .frame(width: 56, height: 56)
            .background(backgroundColor)
            .cornerRadius(100)
            .onAppear {
                DispatchQueue.main.async {
                    self.isAnimating = false
                }
            }
        }
    }

    private var animationStack: some View {
        ZStack {
            Circle()
                .fill(backgroundColor.opacity(0.25))
                .frame(width: 56, height: 56)
                .scaleEffect(self.isAnimating ? 1.8 : 1)
            Circle()
                .fill(backgroundColor.opacity(0.35))
                .frame(width: 56, height: 56)
                .scaleEffect(self.isAnimating ? 1.3 : 1)
            Circle()
                .fill(backgroundColor)
                .frame(width: 56, height: 56)
        }
        .animation(
            Animation.linear(duration: 1)
                .delay(0.2)
                .repeatForever(autoreverses: false)
        )
    }

}

struct RecordingButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordingButton(isRecording: false,
                        background: .red)
    }
}
