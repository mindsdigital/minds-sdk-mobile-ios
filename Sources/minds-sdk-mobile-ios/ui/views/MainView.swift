//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI

public struct MainView: View {
    @State var viewModel: MainViewModel
    @Binding var voiceRecordingFlowActive: Bool
    var delegate: MindsSDKDelegate?

    public init(voiceRecordingFlowActive: Binding<Bool>,
                delegate: MindsSDKDelegate?) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
        self.delegate = delegate
        self.viewModel = MainViewModel(delegate: delegate)
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
        NavigationLink(destination: VoiceRecordingView(model: viewModel.voiceRecordModel),
                       isActive:  $voiceRecordingFlowActive) {
            EmptyView()
        }
        .isDetailLink(false)
        .navigationBarBackButtonHidden(true)
    }
}
