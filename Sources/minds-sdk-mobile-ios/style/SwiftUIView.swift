//
//  SwiftUIView.swift
//  
//
//  Created by Liviu Bosbiciu on 05.04.2022.
//

import SwiftUI

@available(macOS 11, *)
@available(iOS 13.0, *)
struct FillButtonStyleModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
            .background(backgroundColor)
            .cornerRadius(100)
            .opacity(isEnabled ? 1 : 0.5)
    }
}

@available(macOS 11, *)
@available(iOS 13.0, *)
struct OutlinedButtonStyleModifier: ViewModifier {
    var outlineColor: Color
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color(.black))
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.5)
                        .foregroundColor(outlineColor))
    }
}

@available(macOS 11, *)
@available(iOS 13.0, *)
extension View {
    func fillButtonStyle(backgroundColor: Color) -> some View {
        self.modifier(FillButtonStyleModifier(backgroundColor: backgroundColor))
    }
    
    func outlinedButtonStyle(outlineColor: Color) -> some View {
        self.modifier(OutlinedButtonStyleModifier(outlineColor: outlineColor))
    }
}
