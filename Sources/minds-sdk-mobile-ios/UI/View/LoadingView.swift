//
//  LoadingView.swift
//  
//
//  Created by Liviu Bosbiciu on 05.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 15.0, *)
public struct LoadingView: View {
    @ObservedObject var viewModel: VoiceRecordViewModel
    
    public var body: some View {
        HStack {
            LottieView(name: LottieAnimations.loadingLottieAnimation)
        }
        .frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
        .padding()
        .onAppear {
            viewModel.sendAudioToApi()
        }
    }
}
