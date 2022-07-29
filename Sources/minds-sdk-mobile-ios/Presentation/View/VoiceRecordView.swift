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
    @Binding var showBiometricsFlow: Bool
    @State var biometricsResponse: BiometricResponse? = nil
    private var dismiss: (() -> Void)?
    
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
                        Text(viewModel.livenessText())
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
                        .scaleEffect(viewModel.state ==  .recording ? 1.25 : 1)
                        .padding()
                        VStack {
                            Text("Minds Digital")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Text("Versão 1.0.0")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }.padding()
                        
                    }
                }
            }
        }
        .alert(MindsStrings.voiceRecordingAlertSubtitle(), isPresented: viewModel.state.isError) {
            Button(MindsStrings.voiceRecordingAlertNeutralButtonLabel()) {
                showBiometricsFlow = false
                dismiss?()
                viewModel.doBiometricsLater()
            }
            Button(MindsStrings.voiceRecordingAlertButtonLabel(), role: .cancel) { }
                }
        .navigationBarHidden(true)
    }
}
