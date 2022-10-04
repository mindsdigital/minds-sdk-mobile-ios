//
//  SwiftUIView.swift
//  
//
//  Created by Guilherme Domingues on 04/10/22.
//

import SwiftUI

struct MicrophonePermissionView: View {

    var askLater: (() -> Void)? = nil
    var showPrompt: (() -> Void)? = nil

    var body: some View {
        VStack {
            
            Text("Permitir microfone")

            HStack {
                Button {
                    askLater?()
                } label: {
                    Text("Depois")
                }

                Button {
                    showPrompt?()
                } label: {
                    Text("Permitir")
                }
            }
        }
    }

}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        MicrophonePermissionView()
    }
}
