//
//  VoiceRecordingView.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public struct VoiceRecordingView: View {
    @ObservedObject var uiMessagesSdk: MindsSDKUIMessages = MindsSDKUIMessages.shared
    @ObservedObject var uiConfigSdk = MindsSDKUIConfig.shared
    @State var showActionSheet: Bool = false
    @State var selectedRecording: RecordingItem? = nil
    @State var selectedRecordingIndex: Int = 0
    @StateObject var audioRecorder: AudioRecorder = AudioRecorder()
    
    public init() {
        
    }
    
    func fetchRecording(key: String) -> URL? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.temporaryDirectory
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            if (audio.lastPathComponent.starts(with: key)) {
                return audio
            }
        }
        return nil
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1), id: \.self) { i in
                        Text(uiMessagesSdk.recordingItems[i].key)
                            .foregroundColor(i != min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1) - 1 ? Color.gray : uiConfigSdk.hexVariant100)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                    .headline : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .headline)
                            )
                        Text(uiMessagesSdk.recordingItems[i].value)
                            .foregroundColor(i != min(uiMessagesSdk.recordingItems.count, audioRecorder.recordingsCount + 1) - 1 ? Color.gray : uiConfigSdk.hexVariant300)
                            .font(uiConfigSdk.fontFamily.isEmpty ?
                                    .title2 : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .title2)
                            )
                        if (uiMessagesSdk.recordingItems[i].recording != nil) {
                            RecordingItemView(audioURL: uiMessagesSdk.recordingItems[i].recording!,
                                              displayRemoveButton: i == audioRecorder.recordingsCount - 1,
                                              onDeleteAction: {
                                selectedRecording = uiMessagesSdk.recordingItems[i]
                                selectedRecordingIndex = i
                                self.showActionSheet = true
                            })
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Bottom Recording View
            VStack {
                Divider()
                Group {
                    Text(audioRecorder.recording ? uiMessagesSdk.recordingIndicativeText : uiMessagesSdk.instructionTextForRecording)
                        .foregroundColor(uiConfigSdk.textColor)
                        .font(uiConfigSdk.fontFamily.isEmpty ?
                                .body : .custom(uiConfigSdk.fontFamily, size: uiConfigSdk.baseFontSize, relativeTo: .body)
                        )
                        .padding(.top, 5)
                    
                    if audioRecorder.recording {
                        Button(action: {
                            self.audioRecorder.stopRecording()
                            let audio = fetchRecording(key: uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].key)
                            uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].recording = audio
                            audioRecorder.recordingsCount += 1
                        }) {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 56, height: 56)
                        .background(uiConfigSdk.hexVariant400)
                        .cornerRadius(100)
                    } else {
                        Button(action: {
                            if (audioRecorder.recordingsCount < uiMessagesSdk.recordingItems.count) {
                                self.audioRecorder.startRecording(key: uiMessagesSdk.recordingItems[audioRecorder.recordingsCount].key)
                            }
                        }) {
                            Image(uiImage: UIImage(named: "voice", in: .module, with: nil)!)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(uiConfigSdk.hexVariant400)
                        }
                        .frame(width: 56, height: 56)
                        .background(uiConfigSdk.hexVariant400)
                        .cornerRadius(100)
                    }
                }
                .padding(.horizontal)
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text(uiMessagesSdk.deleteMessageTitle),
                        message: Text(uiMessagesSdk.deleteMessageBody),
                        buttons: [
                            .cancel(
                                Text(uiMessagesSdk.dismissDeleteButtonLabel)),
                            .destructive(
                                Text(uiMessagesSdk.confirmDeleteButtonLabel),
                                action: {
                                    if (selectedRecording != nil && selectedRecording!.recording != nil) {
                                        audioRecorder.deleteRecording(urlsToDelete: [
                                            selectedRecording!.recording!
                                        ])
                                        uiMessagesSdk.recordingItems[selectedRecordingIndex].recording = nil
                                    }
                                }
                            )
                        ]
            )
        }
    }
}

@available(macOS 11, *)
@available(iOS 14.0, *)
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
        uiMessagesSdk.deleteMessageTitle = "Exclusão de áudio"
        uiMessagesSdk.deleteMessageBody = "Tem certeza que deseja excluir a sua gravação? Você terá que gravar novamente"
        uiMessagesSdk.confirmDeleteButtonLabel = "Sim, excluir áudio"
        uiMessagesSdk.dismissDeleteButtonLabel = "Não, não excluir"
        
        return VoiceRecordingView()
    }
}
