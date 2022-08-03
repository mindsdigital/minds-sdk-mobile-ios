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
    weak var delegate: MindsSDKDelegate?
    var completion: (() -> Void)?

    public init(voiceRecordingFlowActive: Binding<Bool>,
                delegate: MindsSDKDelegate? = nil,
                completion: (() -> Void)? = nil) {
        self._voiceRecordingFlowActive = voiceRecordingFlowActive
        self.delegate = delegate
        self.completion = completion
    }

    public var body: some View {
        switch viewModel.state {
        case .loaded:
                VoiceRecordView(delegate: self.delegate) {
                    voiceRecordingFlowActive = false
                    completion?()
                }
                .preferredColorScheme(.light)
        case .loading:
            ProgressView()
                .onAppear {
                    viewModel.loadData()
                    viewModel.delegate = delegate
                }
                .navigationBarBackButtonHidden(true)
                .preferredColorScheme(.light)
        }
    }
}

