//
//  NWTextViewRepresentable.swift
//  DesignSystem
//
//  Created by 김시종 on 6/19/25.
//

import UIKit
import SwiftUI

public struct NWTextViewRepresentable: UIViewRepresentable {
    @Binding public var text: String
    @Binding public var errorMessage: String?
    @Binding public var isEditing: Bool
    public let placeholder: String
    public let currentState: NWTextFieldState
    
    public init(
        text: Binding<String>,
        errorMessage: Binding<String?>,
        isEditing: Binding<Bool>,
        placeholder: String,
        currentState: NWTextFieldState
    ) {
        self._text = text
        self._errorMessage = errorMessage
        self._isEditing = isEditing
        self.placeholder = placeholder
        self.currentState = currentState
    }
    
    public func makeCoordinator() -> NWTextViewCoordinator {
        NWTextViewCoordinator(
            text: $text,
            errorMessage: $errorMessage,
            isEditing: $isEditing,
            placeholder: placeholder
        )
    }
    
    public func makeUIView(context: Context) -> NWUITextView {
        let textView = createTextView(context: context)
        configureTextView(textView)
        setupInitialContent(textView)
        return textView
    }
    
    public func updateUIView(_ uiView: NWUITextView, context: Context) {
        updateTextContent(uiView)
    }
    
    // MARK: - Private Methods
    private func createTextView(context: Context) -> NWUITextView {
        let textView = NWUITextView()
        textView.delegate = context.coordinator
        return textView
    }
    
    private func configureTextView(_ textView: NWUITextView) {
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        
        textView.textAlignment = .left
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.widthTracksTextView = true
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.size = CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude)
        
        textView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        textView.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 16)
        textView.textColor = UIColor(DS.Colors.Text.netural)
    }
    
    private func setupInitialContent(_ textView: NWUITextView) {
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor(DS.Colors.Neutral.gray400)
        } else {
            textView.text = text
            textView.textColor = UIColor(DS.Colors.Text.netural)
        }
    }
    
    private func updateTextContent(_ uiView: NWUITextView) {
        if text.isEmpty {
            if isEditing {
                if uiView.text != "" {
                    uiView.text = ""
                    uiView.textColor = UIColor(DS.Colors.Text.netural)
                }
            } else {
                if uiView.text != placeholder {
                    uiView.text = placeholder
                    uiView.textColor = UIColor(DS.Colors.Neutral.gray400)
                }
            }
            return
        }
        
        if !text.isEmpty && uiView.text != text {
            uiView.text = text
            uiView.textColor = UIColor(DS.Colors.Text.netural)
        }
    }
}
