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
    
    public func setColorSwatch(
        hexVariant50: Color,
        hexVariant100: Color,
        hexVariant200: Color,
        hexVariant300: Color,
        hexVariant400: Color,
        hexVariant500: Color,
        hexVariant600: Color,
        hexVariant700: Color,
        hexVariant800: Color,
        hexVariant900: Color
    ) {
        self.hexVariant50 = hexVariant50
        self.hexVariant100 = hexVariant100
        self.hexVariant200 = hexVariant200
        self.hexVariant300 = hexVariant300
        self.hexVariant400 = hexVariant400
        self.hexVariant500 = hexVariant500
        self.hexVariant600 = hexVariant600
        self.hexVariant700 = hexVariant700
        self.hexVariant800 = hexVariant800
        self.hexVariant900 = hexVariant900
    }
    
    @Published public var showThankYouScreen: Bool = true
    @Published private var showBiometricsSkipButton: Bool = true
    @Published private var showOnboardScreen: Bool = true
    @Published private var showTryAgainLaterButton: Bool = false

    // Mark: - Text Color
    @Published public var textColor: Color = Color(.label)

    // Mark: - Image
    @Published private var loadingImage: String = ""

    // Mark: - Font Configuration
    @Published private var baseFontSize: CGFloat = 16
    @Published private var fontFamily: String = ""

    @Published private var buttonErrorColor: Color = Color(.label)

    @Published public var hexVariant50: Color = Color(hex: "fff7e0")
    @Published public var hexVariant100: Color = Color(hex: "ffe9b0")
    @Published public var hexVariant200: Color = Color(hex: "feda7e")
    @Published public var hexVariant300: Color = Color(hex: "fdcd49")
    @Published public var hexVariant400: Color = Color(hex: "fcc11f")
    @Published public var hexVariant500: Color = Color(hex: "fbb700")
    @Published public var hexVariant600: Color = Color(hex: "fba900")
    @Published public var hexVariant700: Color = Color(hex: "fb9600")
    @Published public var hexVariant800: Color = Color(hex: "fb8500")
    @Published public var hexVariant900: Color = Color(hex: "fa6400")

    // Mark: - Screen configurations

    public func disableSkipBiometrics() {
        self.showBiometricsSkipButton = false
    }

    func showSkipBiometrics() -> Bool {
        showBiometricsSkipButton
    }

    public func setRetryLaterButtonLabel(visible: Bool) {
        self.showTryAgainLaterButton = visible
    }

    func showTryAgainLater() -> Bool {
        showTryAgainLaterButton
    }

    public func disableOnboardScreen() {
        self.showOnboardScreen = false
    }

    func showOnboard() -> Bool {
        return showOnboardScreen
    }

    // Mark:  - UI Configurations
    
    public func setFontFamilyFile(fontFamily: String) {
        self.fontFamily = fontFamily
    }

    func getFontFamily() -> String {
        return fontFamily
    }

    public func setTypographyScale(baseFontSize: CGFloat) {
        self.baseFontSize = baseFontSize
    }

    func getTypographyScale() -> CGFloat {
        return baseFontSize
    }

    public func setLogoImage(loadingImage: String) {
        self.loadingImage = loadingImage
    }

    func getLogoImage() -> String {
        return loadingImage
    }

    public func setTextColor(textColor: Color) {
        self.textColor = textColor
    }

    func getTextColor() -> Color {
        return textColor
    }

    public func setButtonErrorColor(color: Color) {
        self.buttonErrorColor = color
    }

    func getButtonErrorColor() -> Color {
        return buttonErrorColor
    }
}
