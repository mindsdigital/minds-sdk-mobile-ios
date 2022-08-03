//
//  File.swift
//  
//
//  Created by Guilherme Domingues on 09/07/22.
//

import Foundation
import SwiftUI

public struct MainView: View {
    @State var viewModel = MainViewModel()
    @Binding var voiceRecordingFlowActive: Bool
    weak var delegate: MindsSDKDelegate?

    public init(voiceRecordingFlowActive: Binding<Bool>,
                delegate: MindsSDKDelegate? = nil) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
        self.delegate = delegate
        self.viewModel.delegate = delegate
    }

    public var body: some View {
        switch viewModel.state {
        case .loaded:
                VoiceRecordView(delegate: self.delegate) {
                    voiceRecordingFlowActive = false
                }
                .preferredColorScheme(.light)
        case .loading:
            ProgressView()
                .onAppear {
                    viewModel.loadData()
                }
                .navigationBarBackButtonHidden(true)
                .preferredColorScheme(.light)
        }
    }
}

