//
//  MindsSDKUIConfig.swift
//  
//
//  Created by Liviu Bosbiciu on 04.04.2022.
//

import Foundation
import SwiftUI

@available(macOS 11, *)
@available(iOS 14.0, *)
public class MindsSDKUIConfig: ObservableObject {
    static public let shared = MindsSDKUIConfig()
    
    public init() {
        
    }
    
    // @Published public var colorSwatch: String = "" // todo: change this accordingly
    @Published public var textColor: Color = Color(.label)
    @Published public var showThankYouScreen: Bool = true // todo: unused for now
    @Published public var showBiometricsSkipButton: Bool = true
    @Published public var baseFontSize: CGFloat = 16
    @Published public var fontFamily: String = ""
    @Published public var loadingImage: String = "robot" // todo: make sure to test both with SDK assets and sample app assets
}
