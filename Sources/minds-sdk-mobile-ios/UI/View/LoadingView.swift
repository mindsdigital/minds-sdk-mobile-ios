//
//  LoadingView.swift
//  
//
//  Created by Liviu Bosbiciu on 05.04.2022.
//

import SwiftUI

@available(iOS 13.0, *)
public struct LoadingView: View {

    public var body: some View {
        HStack {
            LottieView(name: LottieAnimations.loadingLottieAnimation)
        }
        .frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
        .padding()
        .preferredColorScheme(.light)
        .navigationBarHidden(true)
    }
}
