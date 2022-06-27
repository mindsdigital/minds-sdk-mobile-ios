//
//  SwiftUIView.swift
//  
//
//  Created by Guilherme Domingues on 23/06/22.
//

import SwiftUI

private class HighlightedText: Identifiable {
    let id: UUID = UUID()
    let text: String

    init(text: String) {
        self.text = text
    }
}

struct SequentialTextWithAnimation: View {
    private var texts: [HighlightedText]
    var textColor: Color
    var font: Font

    @State private var highlightedIndex: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(texts: [String], textColor: Color, font: Font) {
        self.texts = texts.map { HighlightedText(text: $0) }
        self.textColor = textColor
        self.font = font
    }

    var body: some View {
        ForEach(texts, id: \.id) { loadingIndicativeText in
            Text(loadingIndicativeText.text)
                .foregroundColor(textColor.opacity(setOpacity(for: loadingIndicativeText)))
                .font(font)
        }
        .onReceive(timer) { _ in
            self.highlightedIndex = (highlightedIndex + 1) % texts.count
        }
    }

    private func setOpacity(for text: HighlightedText) -> CGFloat {
        if isCurrentHighlighted(text) {
            return 1.0
        }
        return 0.2
    }

    private func isCurrentHighlighted(_ text: HighlightedText) -> Bool {
        return texts[highlightedIndex].id == text.id
    }
}
