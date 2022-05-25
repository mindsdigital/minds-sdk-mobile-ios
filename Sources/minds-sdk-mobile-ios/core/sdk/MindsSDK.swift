//
//  File.swift
//  
//
//  Created by Liviu Bosbiciu on 12.04.2022.
//

import Foundation

@available(macOS 11, *)
@available(iOS 14.0, *)

public enum ProcessType {
    case enrollment, verification
}

public class MindsSDK: ObservableObject {
    static public let shared = MindsSDK()
    
    public init() { }
    
    @Published public var token: String = ""
    @Published public var cpf: String = ""
    @Published public var externalId: String = ""
    @Published public var phoneNumber: String = ""
    
    @Published public var sampleRate: Int = 16000
    @Published public var channelConfig: String = "" // todo: unused for now
    @Published public var linearPCMBitDepthKey: Int = 16
    @Published public var fileExtension: String = "wav"
    @Published public var processType: ProcessType

    func setProcessType(processType: ProcessType) {
        self.processType = processType
    }
}
