//
//  TimerComponent.swift
//  
//
//  Created by Guilherme Domingues on 02/08/22.
//

import SwiftUI

struct TimerComponent: View {
    private var timer = Timer.publish(every: 1,
                                      on: .main,
                                      in: .common).autoconnect()
    @State var counter: Int = 0
    var stoped: ((Int) -> Void)? = nil
    @State private var maskedTimer: String = "00:00"

    init(stoped: ((Int) -> Void)? = nil) {
        self.stoped = stoped
    }

    var body: some View {
        Text("\(maskedTimer)")
            .onReceive(timer) { _ in
                counter += 1
                self.maskedTimer = maskTimer()
            }
            .onDisappear {
                stoped?(counter)
            }
    }

    private func maskTimer() -> String {
        let seconds = String(format: "%.2d", counter % 60)
        let minutes = String(format: "%.2d", (counter / 60) % 60)
        return "\(minutes):\(seconds)"
    }
}
