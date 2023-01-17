//
//  Tooltip.swift
//  
//
//  Created by Guilherme Domingues on 03/08/22.
//

import SwiftUI

@available(iOS 13.0, *)
struct Tooltip: View {

    private var timer = Timer.publish(every: 1,
                                      on: .main,
                                      in: .common).autoconnect()
    @State private var seconds: Int = 0
    @State private var animate: Bool = false

    var text: String
    var secondsOnScreen: Int
    var onTimeReached: (() -> Void)?
    var animationDuration: Double = 0.5

    init(text: String, secondsOnScreen: Int = 3,
         onTimeReached: (() -> Void)? = nil) {
        self.text = text
        self.secondsOnScreen = secondsOnScreen
        self.onTimeReached = onTimeReached
    }

    var body: some View {
        Rectangle()
            .fill(Color.baselinePrimary)
            .cornerRadius(10)
            .overlay(
                Text(text)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
            )
            .frame(width: 240, height: 50)
            .onReceive(timer) { value in
                seconds += 1
                if seconds >= secondsOnScreen {
                    onTimeReached?()
                }
            }
            .onAppear(perform: {
                self.dispatchAnimationOnMainThread()
            })
            .opacity(animate ? 0.8 : 0)
    }

    private func dispatchAnimationOnMainThread() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation(Animation.easeIn(duration: animationDuration)) {
                self.animate = true
            }
            withAnimation(Animation
                            .easeIn(duration: animationDuration)
                            .delay(animationDelay())) {
                self.animate = false
            }
        }
    }

    private func animationDelay() -> Double {
        return Double(secondsOnScreen) - animationDuration
    }
}
