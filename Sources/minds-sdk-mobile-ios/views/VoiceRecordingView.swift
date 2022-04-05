//
//  VoiceRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 13.0, *)
public struct VoiceRecordingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    
#if !os(macOS)
    @State var offset : CGFloat = UIScreen.main.bounds.height
#endif
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(uiMessagesSdk.recordingItems, id: \.self) { recordingItem in
                        Text(recordingItem.key)
                        Text(recordingItem.value)
                        RecordingItemView(onDeleteAction: {
#if !os(macOS)
                            self.offset = 0
#endif
                        })
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            BottomRecordingView()
                .frame(maxHeight: .infinity, alignment: .bottom)
            
            VStack{
                
                Spacer()
#if !os(macOS)
                CustomActionSheet()

                    .offset(y: self.offset)

                    .gesture(DragGesture()
                             
                                .onChanged({ (value) in
                        
                        if value.translation.height > 0{
                            
                            self.offset = value.location.y
                            
                        }
                    })
                                .onEnded({ (value) in
                        
                        if self.offset > 100{
                            
                            self.offset = UIScreen.main.bounds.height
                        }
                        else{
                            
                            self.offset = 0
                        }
                    })
                    )
#endif
                
            }
#if !os(macOS)
            .background((self.offset <= 100 ? Color(UIColor.label).opacity(0.3) : Color.clear).edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                
                self.offset = 0
                
            })
#endif
            
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

@available(macOS 11, *)
@available(iOS 13.0, *)
struct VoiceRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        let uiMessagesSdk = MindsSDKUIMessages.shared
        var recordingItems: [RecordingItem] = []
        recordingItems.append(RecordingItem(key: "NOME COMPLETO",
                                            value: "Divino Borges de Oliveira Filho"))
        recordingItems.append(RecordingItem(key: "DATA DE NASCIMENTO",
                                            value: "18/09/1967"))
        uiMessagesSdk.recordingItems = recordingItems
        uiMessagesSdk.recordingIndicativeText = "Gravando... Leia o texto acima"
        uiMessagesSdk.instructionTextForRecording = "Aperte e solte o botão abaixo para iniciar a gravação"
        
        return VoiceRecordingView()
            .environmentObject(uiMessagesSdk)
    }
}
