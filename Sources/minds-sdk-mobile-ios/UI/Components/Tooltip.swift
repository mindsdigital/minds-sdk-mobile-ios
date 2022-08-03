//
//  Tooltip.swift
//  
//
//  Created by Guilherme Domingues on 03/08/22.
//

import SwiftUI

struct Tooltip: View {

    var text: String

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(Color.baselinePrimary)
                    .cornerRadius(10)
                    .overlay(
                        Text(text)
                    )
                HStack {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 20, height: 20)
                        .cornerRadius(3)
                }
            }
            .frame(width: 160, height: 30)
        }
    }
}
