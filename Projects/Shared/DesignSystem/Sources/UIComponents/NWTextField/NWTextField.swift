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
        errorMessage: Binding<String?> = .constant(nil)
    ) {
        self._text = text
        self.placeholder = placeholder
        self._errorMessage = errorMessage
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
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            textViewRepresentable
            
            if !text.isEmpty {
                clearButton
            }
        }
        .background(Color.clear)
        .overlay(borderView, alignment: .bottom)
        .animation(.easeInOut(duration: 0.2), value: currentState.borderColor)
        .animation(.easeInOut(duration: 0.2), value: currentState.borderWidth)
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
                    .font(.system(size: 22))
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
        // 즉시 UI 업데이트를 위해 강제로 상태 변경
        DispatchQueue.main.async {
            // 빈 문자열 설정이 바로 반영되도록 함
        }
    }
}

// MARK: - Extensions
public extension NWTextField {
    func errorMessage(_ message: String?) -> NWTextField {
        var copy = self
        copy._errorMessage = .constant(message)
        return copy
    }
    
    func placeholder(_ text: String) -> NWTextField {
        NWTextField(
            text: self._text,
            placeholder: text,
            errorMessage: self._errorMessage
        )
    }
}
