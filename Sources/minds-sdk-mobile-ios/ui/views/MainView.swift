//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @Binding var voiceRecordingFlowActive: Bool
    private var dismiss: (() -> Void)?

    public init(voiceRecordingFlowActive: Binding<Bool>,
                dismiss: (() -> Void)? = nil) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
        self.dismiss = dismiss
    }

    public var body: some View {
        switch viewModel.state {
        case .loaded(let showOnboarding):
            if showOnboarding {
                onboarding
            } else {
                voiceRecording
            }
        case .loading:
            ProgressView()
                .onAppear {
                    viewModel.loadData()
                }
                .navigationBarBackButtonHidden(true)
        }
    }

    private var onboarding: some View {
        NavigationLink(destination: OnboardingView(voiceRecordingFlowActive: $voiceRecordingFlowActive,
                                                   dismiss: dismiss),
                       isActive:  $voiceRecordingFlowActive) {
            EmptyView()
        }
        .isDetailLink(false)
        .navigationBarBackButtonHidden(true)
    }

    private var voiceRecording: some View {
        NavigationLink(destination: VoiceRecordingView(voiceRecordingFlowActive: $voiceRecordingFlowActive),
                       isActive:  $voiceRecordingFlowActive) {
            EmptyView()
        }
        .isDetailLink(false)
        .navigationBarBackButtonHidden(true)
    }
}

