//
//  SwiftUIView.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import SwiftUI
import AVFAudio

@available(macOS 11, *)
@available(iOS 15.0, *)
struct VoiceRecordView: View {
    @StateObject var viewModel = VoiceRecordViewModel()
    
//    @State var hasPressed = false
//    @State var showLoadingView: Bool = false
//    @State var hasError: Bool = false
//    @State var hasSuccess: Bool = false
    @Binding var showBiometricsFlow: Bool
    @State var biometricsResponse: BiometricResponse? = nil
    private var dismiss: (() -> Void)?
//    @Binding var biometricsResponse: BiometricResponse
    
    init(showBiometricsFlow: Binding<Bool>,
         dismiss: (() -> Void)? = nil) {
        self._showBiometricsFlow = showBiometricsFlow
        self.dismiss = dismiss
    }
    
    @available(iOS 15.0, *)
    var body: some View {
        NavigationView {
            if viewModel.state == .loading {
                LoadingView(viewModel: viewModel)
            } else {
                VStack(spacing: 0.0) {
                    VStack(alignment: .leading, spacing: 0.0) {
                        Text(MindsStrings.voiceRecordingTitle())
                            .font(.headline)
                            .padding(0.0)
                        Text(MindsStrings.voiceRecordingSubtitle())
                            .font(.subheadline)
                            .padding(0.0)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(MindsSDK.shared.livenessText)
                            .font(.largeTitle)
                            .padding()
                    }
                    Spacer()
                    VStack {
                        HStack {
                            if (viewModel.state == .recording) {
                                LottieView(name: LottieAnimations.audioRecordingLottieAnimation)

                            }
                        }.frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
                            Image(systemName: "mic.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color.white)
                                .onLongPressGesture(minimumDuration: 1.5, maximumDistance: 100, pressing: {
                                                            pressing in
                                                            
                                                            if pressing {
                                                                viewModel.startRecording()
                                                            }
                                                        }, perform: {})
                                .simultaneousGesture(
                                    DragGesture(minimumDistance: 0)
                                        .onEnded{ _ in
                                            viewModel.stopRecording()
                                            }
                                    )
                        .frame(width: 56, height: 56)
                        .background(Color(hex: "00DDB8"))
                        .cornerRadius(100)
                        .padding()
                        Text("Minds Digital\nVersão 1.0.0")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .padding()
                    }
                }
            }
        }
        .alert(MindsStrings.voiceRecordingAlertSubtitle(), isPresented: viewModel.state.isError) {
            Button(MindsStrings.voiceRecordingAlertNeutralButtonLabel()) {
                showBiometricsFlow = false
//                dismiss?()
                viewModel.doBiometricsLater()
            }
            Button(MindsStrings.voiceRecordingAlertButtonLabel(), role: .cancel) { }
                }
        .navigationBarHidden(true)
    }
}
