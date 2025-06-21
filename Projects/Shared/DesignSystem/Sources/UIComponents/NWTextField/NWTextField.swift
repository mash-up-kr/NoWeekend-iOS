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
        return textLineCount > 1
    }
    
    // MARK: - Initialization
    public init(
        text: Binding<String>,
        placeholder: String = "",
        errorMessage: Binding<String?> = .constant(nil),
        style: NWTextFieldStyle = .todoMultiLine
    ) {
        self._text = text
        self.placeholder = placeholder
        self._errorMessage = errorMessage
        self.style = style
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
            if !text.isEmpty {
                clearButton
            }
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
            currentState: currentState
        )
        .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if !text.isEmpty {
            Button(action: clearText) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(DS.Colors.Neutral._400)
                    .font(.system(size: 20))
            }
        }
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
                .foregroundColor(DS.Colors.TaskItem.orange) // 추후 색상 수정 예정
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
        return NWTextField(
            text: self._text,
            placeholder: self.placeholder,
            errorMessage: .constant(message),
            style: self.style
        )
    }
    
    func placeholder(_ text: String) -> NWTextField {
        return NWTextField(
            text: self._text,
            placeholder: text,
            errorMessage: self._errorMessage,
            style: self.style
        )
    }
    
    func style(_ style: NWTextFieldStyle) -> NWTextField {
        return NWTextField(
            text: self._text,
            placeholder: self.placeholder,
            errorMessage: self._errorMessage,
            style: style
        )
    }
    
    func suffix(_ text: String) -> NWTextField {
        return NWTextField(
            text: self._text,
            placeholder: self.placeholder,
            errorMessage: self._errorMessage,
            style: .userInputTextField(text)
        )
    }
}

public extension NWTextField {
    static func todoMultiLine(
        text: Binding<String>,
        placeholder: String = "",
        errorMessage: Binding<String?> = .constant(nil)
    ) -> NWTextField {
        return NWTextField(
            text: text,
            placeholder: placeholder,
            errorMessage: errorMessage,
            style: .todoMultiLine
        )
    }
    
    static func userInputTextField(
        text: Binding<String>,
        suffixText: String,
        placeholder: String = "",
        errorMessage: Binding<String?> = .constant(nil)
    ) -> NWTextField {
        return NWTextField(
            text: text,
            placeholder: placeholder,
            errorMessage: errorMessage,
            style: .userInputTextField(suffixText)
        )
    }
}
