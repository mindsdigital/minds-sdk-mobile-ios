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

    init(stoped: ((Int) -> Void)? = nil) {
        self.stoped = stoped
    }

    var body: some View {
        Text("\(counter)")
            .onReceive(timer) { _ in
                counter += 1
            }
            .onDisappear {
                stoped?(counter)
            }
    }
}
