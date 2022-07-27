//
//  VoiceRecordingView.swift
//  
//
//  Created by Guilherme Domingues on 24/07/22.
//

import SwiftUI

class VoiceRecordingViewModel: ObservableObject {
    var uiConfigSdk = MindsSDKUIConfig.shared
    @Published var livenessText: String = ""

    func updateLivenessText(using item: RecordingItem) {
        self.livenessText = item.value
    }
}

struct VoiceRecordingView: View {

    @ObservedObject var model: VoiceRecordingViewModel

    var body: some View {
        VStack {
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
            
            Spacer()

            HStack {
                Text(model.livenessText)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.custom(model.uiConfigSdk.getFontFamily(), size: 24))
                Spacer()
            }
            
            Spacer()
            
            Button {
                print("text")
            } label: {
                ZStack(alignment: .center) {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    Image(uiImage: UIImage(named: "voice", in: .module, with: nil) ?? UIImage())
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
            }

            Spacer()

            Text("Desenvolvido por Minds Digital")
                .font(.custom(model.uiConfigSdk.getFontFamily(), size: 8))
        }
        .padding(.horizontal, 24)
    }
}

struct VoiceRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceRecordingView(model: VoiceRecordingViewModel())
    }
}
