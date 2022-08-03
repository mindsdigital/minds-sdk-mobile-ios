//
//  SwiftUIView.swift
//  
//
//  Created by Divino Borges on 28/07/22.
//

import SwiftUI
import AVFAudio

struct VoiceRecordView: View {
    @ObservedObject var viewModel: VoiceRecordViewModel
    @State var fadeIn: Bool = false
    @State var showTooltip: Bool = false

    init(delegate: MindsSDKDelegate?,
         completion: (() -> Void)? = nil) {
        self.viewModel = VoiceRecordViewModel(mindsDelegate: delegate,
                                              completion: completion)
    }

    var body: some View {
        NavigationView {
            if viewModel.state == .loading {
                LoadingView()
            } else {
                VStack(spacing: 0.0) {
                    VStack(alignment: .leading, spacing: 0.0) {
                        HStack {
                            Text(MindsStrings.voiceRecordingTitle())
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text(MindsStrings.voiceRecordingSubtitle())
                                .font(.subheadline)
                            Spacer()
                        }
                    }

                    Spacer()

                    VStack(spacing: 24) {
                        HStack {
                            Text(viewModel.livenessText())
                                .font(.largeTitle)
                            Spacer()
                        }

                        HStack {
                            if (viewModel.state == .recording) {
                                recordingWaveAndTimer()
                            }
                        }.frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: 80.0)
                    }

                    Spacer()

                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            RecordingButton(longPressMinDuration: 0.3,
                                            onLongPress: viewModel.startRecording,
                                            onTap: { self.showTooltip = true },
                                            onRelease: viewModel.stopRecording)
                        }

                        VStack {
                            Text("Minds Digital")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            Text("Versão \(Version.versionCode)")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                        .padding(.top, 24)
                    }
                }
            }
        }
        .padding(24)
        .alert(isPresented: viewModel.state.isError) {
            alert()
        }
        .onAppear(perform: {
            self.dispatchAnimationOnMainThread()
        })
        .opacity(fadeIn ? 1 : 0)
        .navigationBarHidden(true)
        .disableRotation()
        .preferredColorScheme(.light)
    }

    private func recordingWaveAndTimer() -> some View {
        VStack {
            LottieView(name: LottieAnimations.audioRecordingLottieAnimation)
            TimerComponent(stoped: viewModel.setAudioDuration)
        }
    }

    private func dispatchAnimationOnMainThread() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            withAnimation(Animation.easeIn(duration: 1)) {
                self.fadeIn = true
            }
        }
    }

    private func alert() -> Alert {
        if case let VoiceRecordState.error(errorType) = viewModel.state {
            switch errorType {
            case .invalidLength:
                return invalidLengthAlert(errorType)
            case .generic:
                return genericAlert(errorType)
            }
        }

        return Alert(title: Text(""),
                     message: Text(""),
                     primaryButton: .cancel(),
                     secondaryButton: .cancel())
    }

    private func invalidLengthAlert(_ errorType: VoiceRecordErrorType) -> Alert {
        return Alert(title: Text(errorType.title),
                     message: Text(errorType.subtitle),
                     dismissButton: .cancel(Text(errorType.dismissButtonLabel)))
    }

    private func genericAlert(_ errorType: VoiceRecordErrorType) -> Alert {
        return Alert(title: Text(errorType.title),
                     message: Text(errorType.subtitle),
                     primaryButton: .cancel(Text(errorType.primaryActionLabel),
                                            action: viewModel.doBiometricsLater),
                     secondaryButton: .destructive(Text(errorType.dismissButtonLabel)))
    }
}
