//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI

@available(macOS 11, *)
@available(iOS 15.0, *)
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
        case .loaded:
                voiceRecording
        case .loading:
            ProgressView()
                .onAppear {
                    viewModel.loadData()
                }
                .navigationBarBackButtonHidden(true)
        }
    }

    private var voiceRecording: some View {
        NavigationLink(destination: VoiceRecordView(showBiometricsFlow: $voiceRecordingFlowActive, dismiss: dismiss),
                       isActive:  $voiceRecordingFlowActive) {
            EmptyView()
        }
        .isDetailLink(false)
        .navigationBarBackButtonHidden(true)
    }
}

