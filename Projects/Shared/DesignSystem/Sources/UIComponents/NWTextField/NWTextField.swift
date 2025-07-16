//
//  NWTextField.swift
//  DesignSystem
//
//  Created by 김시종 on 6/19/25.
//

import SwiftUI

public struct NWTextField: View {
    
    // MARK: - Properties
    @Binding private var text: String
    private let placeholder: String
    @Binding private var errorMessage: String?
    @State private var isEditing: Bool = false
    private let style: NWTextFieldStyle
    private let keyboardType: UIKeyboardType
    
    // MARK: - Computed Properties
    private var currentState: NWTextFieldState {
        if let errorMessage = errorMessage, !errorMessage.isEmpty {
            return .typingError
        } else if isEditing {
            return .typing
        } else {
            return .normal
        }
    }
    
    private var isMultiLine: Bool {
        textLineCount > 1
    }
    
    // MARK: - Initialization
    public init(
        text: Binding<String>,
        placeholder: String = "",
        errorMessage: Binding<String?> = .constant(nil),
        style: NWTextFieldStyle = .todoMultiLine,
        keyboardType: UIKeyboardType = .default
    ) {
        self._text = text
        self.placeholder = placeholder
        self._errorMessage = errorMessage
        self.style = style
        self.keyboardType = keyboardType
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            inputFieldView
            errorMessageView
        }
    }
    
    // MARK: - Private Views
    private var inputFieldView: some View {
        HStack(alignment: .top, spacing: 12) {
            textViewRepresentable
            
            rightContentView
                .allowsHitTesting(true)
        }
        .background(Color.clear)
        .overlay(borderView, alignment: .bottom)
        .animation(.easeInOut(duration: 0.2), value: currentState.borderColor)
        .animation(.easeInOut(duration: 0.2), value: currentState.borderWidth)
    }
    
    @ViewBuilder
    private var rightContentView: some View {
        switch style {
        case .todoMultiLine:
            clearButton
                .opacity(text.isEmpty ? 0 : 1)
        case .userInputTextField(let suffixText):
            Text(suffixText)
                .font(.body1)
                .foregroundColor(DS.Colors.Neutral.black)
        }
    }
    
    private var textLineCount: Int {
        let screenWidth = UIScreen.main.bounds.width - 40
        let estimatedCharsPerLine = Int(screenWidth / 12)
        return text.isEmpty ? 1 : max(1, (text.count + estimatedCharsPerLine - 1) / estimatedCharsPerLine)
    }
    
    private var textViewRepresentable: some View {
        NWTextViewRepresentable(
            text: $text,
            errorMessage: $errorMessage,
            isEditing: $isEditing,
            placeholder: placeholder,
            currentState: currentState,
            keyboardType: keyboardType
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private var clearButton: some View {
        Button(action: clearText) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(DS.Colors.Neutral.gray400)
                .contentShape(Rectangle())
                .font(.system(size: 20))
        }
        .buttonStyle(PlainButtonStyle())
        .highPriorityGesture(
            TapGesture()
                .onEnded { _ in
                    clearText()
                }
        )
        .allowsHitTesting(true)
    }
    
    private var borderView: some View {
        Rectangle()
            .frame(height: currentState.borderWidth)
            .foregroundColor(currentState.borderColor)
    }
    
    @ViewBuilder
    private var errorMessageView: some View {
        if let errorMessage = errorMessage, !errorMessage.isEmpty {
            Text(errorMessage)
                .font(.body2)
                .foregroundColor(DS.Colors.Toast._500)
                .transition(.opacity.combined(with: .move(edge: .top)))
        }
    }
    
    // MARK: - Private Methods
    private func clearText() {
        text = ""
        errorMessage = nil
    }
}

// MARK: - Extensions
public extension NWTextField {
    func errorMessage(_ message: String?) -> NWTextField {
        NWTextField(
            text: self._text,
            placeholder: self.placeholder,
            errorMessage: .constant(message),
            style: self.style,
            keyboardType: self.keyboardType
        )
    }
    
    func placeholder(_ text: String) -> NWTextField {
        NWTextField(
            text: self._text,
            placeholder: text,
            errorMessage: self._errorMessage,
            style: self.style,
            keyboardType: self.keyboardType
        )
    }
    
    func style(_ style: NWTextFieldStyle) -> NWTextField {
        NWTextField(
            text: self._text,
            placeholder: self.placeholder,
            errorMessage: self._errorMessage,
            style: style,
            keyboardType: self.keyboardType
        )
    }
    
    func suffix(_ text: String) -> NWTextField {
        NWTextField(
            text: self._text,
            placeholder: self.placeholder,
            errorMessage: self._errorMessage,
            style: .userInputTextField(text),
            keyboardType: self.keyboardType
        )
    }
    
    func keyboardType(_ type: UIKeyboardType) -> NWTextField {
        NWTextField(
            text: self._text,
            placeholder: self.placeholder,
            errorMessage: self._errorMessage,
            style: self.style,
            keyboardType: type
        )
    }
}

public extension NWTextField {
    static func todoMultiLine(
        text: Binding<String>,
        placeholder: String = "",
        errorMessage: Binding<String?> = .constant(nil),
        keyboardType: UIKeyboardType = .default
    ) -> NWTextField {
        NWTextField(
            text: text,
            placeholder: placeholder,
            errorMessage: errorMessage,
            style: .todoMultiLine,
            keyboardType: keyboardType
        )
    }
    
    static func userInputTextField(
        text: Binding<String>,
        suffixText: String,
        placeholder: String = "",
        errorMessage: Binding<String?> = .constant(nil),
        keyboardType: UIKeyboardType = .default
    ) -> NWTextField {
        NWTextField(
            text: text,
            placeholder: placeholder,
            errorMessage: errorMessage,
            style: .userInputTextField(suffixText),
            keyboardType: keyboardType
        )
    }
}
