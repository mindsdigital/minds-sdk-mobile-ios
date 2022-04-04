//
//  SwiftUIView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct OnboardingView: View {
    
    var title: String
    var hintTextTitle: String
    var hintTexts: [String]
    var startRecordingButtonLabel: String
    var skipRecordingButtonLabel: String
    
    public init(
        title: String = "Podemos iniciar a biometria por voz ?",
        hintTextTitle: String = "Dicas",
        hintTexts: [String] = [
            "Não peça para outra pessoa gravar",
            "Esteja em um ambiente sem barulho",
            "Fale próximo ao seu telefone",
        ],
        startRecordingButtonLabel: String = "Sim, iniciar gravações",
        skipRecordingButtonLabel: String = "Não, pular biometria por voz"
    ) {
        self.title = title
        self.hintTextTitle = hintTextTitle
        self.hintTexts = hintTexts
        self.startRecordingButtonLabel = startRecordingButtonLabel
        self.skipRecordingButtonLabel = skipRecordingButtonLabel
    }
    
    public var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 20)
                Text(hintTextTitle)
                    .padding(.bottom, 5)
                VStack(alignment: .leading) {
                    ForEach(hintTexts, id: \.self) { hintText in
                        Text(hintText)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                Button(action: {
                    
                }) {
                    Text(startRecordingButtonLabel)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .cornerRadius(50)
                }
                Button(action: {
                    
                }) {
                    Text(skipRecordingButtonLabel)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .cornerRadius(50)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .padding()
    }
}

@available(macOS 10.15, *)
@available(iOS 13.0, *)
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
