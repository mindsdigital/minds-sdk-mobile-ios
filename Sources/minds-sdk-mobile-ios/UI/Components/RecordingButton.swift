//
//  RecordingButton.swift
//  
//
//  Created by Guilherme Domingues on 22/06/22.
//

import SwiftUI

enum RecordingButtonState {
    case idle, recording
}

struct RecordingButton: View {
    @State private var state: RecordingButtonState = .idle
    @State private var isHolding = false

    var onLongPress: (() -> Void)?
    var onTap: (() -> Void)?
    var onRelease: (() -> Void)?

    private var longPressMinDuration: Double

    init(longPressMinDuration: Double = 0.5,
         onLongPress: (() -> Void)? = nil,
         onTap: (() -> Void)? = nil,
         onRelease: (() -> Void)? = nil) {
        self.longPressMinDuration = longPressMinDuration
        self.onLongPress = onLongPress
        self.onTap = onTap
        self.onRelease = onRelease
    }

    var body: some View {
        buttonLabel
            .onTapGesture {
                isHolding = false
                onTap?()
            }
            .simultaneousGesture(
                LongPressGesture(minimumDuration: longPressMinDuration)
                    .onEnded({ _ in
                        isHolding = true
                        state = .recording
                        onLongPress?()
                    })
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded({ _ in
                        if isHolding {
                            onRelease?()
                            isHolding = false
                            state = .idle
                        }
                    })
            )
    }

    private var buttonLabel: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.baselinePrimary)
                .scaleEffect(state ==  .recording ? 1.25 : 1)
                .frame(width: 76, height: 76)
            buttonImage
        }
    }

    private var buttonImage: some View {
        Group {
            if state == .recording {
                Image(systemName: "stop.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
            } else {
                Image(systemName: "mic.fill")
                    .resizable()
                    .frame(width: 24, height: 34)
                    .foregroundColor(.white)
            }
        }
    }
}

struct RecordingButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordingButton()
    }
}
