//
//  VoiceRecordingView.swift
//  
//
//  Created by Guilherme Domingues on 24/07/22.
//

import SwiftUI

struct VoiceRecordingView: View {

    @ObservedObject var model: VoiceRecordingViewModel

    var body: some View {
        VStack {
            switch model.state {
            case .sending:
                sendingView
            case .error:
                errorView
            default:
                idleView
            }
        }
        .padding(.horizontal, 24)
        .disableRotation()
    }

    private var errorView: some View {
        idleView
            .alert(isPresented: .constant(true)) {
                Alert(
                    title: Text("Ocorreu um erro"),
                    message: Text("Não foi possível carregar as informações. Por favor, tente novamente"),
                    primaryButton: .destructive(Text("Depois"), action: model.doBiometricsLater),
                    secondaryButton: .default(Text("Tentar novamente"))
                )
            }
    }

    private var sendingView: some View {
        VStack {
            Spacer()
            LottieView(name: LottieAnimations.loading)
                .frame(width: 200, height: 200)
            Spacer()
        }
    }

    private var idleView: some View {
        VStack {
            header

            VStack {
                Spacer()
                livenessText
                Spacer()
            }

            if model.state == .recording {
                VStack {
                    Spacer()
                        .frame(height: 24)
                    LottieView(name: LottieAnimations.recordingWave)
                        .frame(width: 200, height: 50)
                    Spacer()
                        .frame(height: 24)
                }
            }

            RecordingButton(longPressMinDuration: 0.3,
                            onLongPress: model.onLongPress,
                            onTap: model.onTap,
                            onRelease: model.onRelease)

            Spacer()

            footer
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Olá! Autentique sua voz")
                    .font(.custom(model.uiConfigSdk.getFontFamily(), size: 18))
                Spacer()
            }
            HStack {
                Text("Segure o botão para iniciar a gravação\ne leia o texto que está na tela.")
                    .font(.custom(model.uiConfigSdk.getFontFamily(), size: 12))
                Spacer()
            }
        }
    }

    private var livenessText: some View {
        HStack {
            Text(model.livenessText)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom(model.uiConfigSdk.getFontFamily(), size: 24))
            Spacer()
        }
    }

    private var footer: some View {
        Text("Desenvolvido por Minds Digital")
            .font(.custom(model.uiConfigSdk.getFontFamily(), size: 8))
    }

}
