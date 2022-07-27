//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI

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
            if #available(iOS 14.0, *) {
            ProgressView()
                .onAppear {
                    viewModel.loadData()
                }
                .navigationBarBackButtonHidden(true)
            } else {
                Text("Loading")
            }
        }
    }

    private var voiceRecording: some View {
        NavigationLink(destination: VoiceRecordingView(model: viewModel.voiceRecordModel),
                       isActive:  $voiceRecordingFlowActive) {
            EmptyView()
        }
        .isDetailLink(false)
        .navigationBarBackButtonHidden(true)
    }
}

