//
//  NWTextField.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/18/25.
//

import SwiftUI

public struct NWTextField: View {
    // MARK: - Properties
    @Binding private var text: String
    private let placeholder: String
    private let errorMessage: String?
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    
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
    
    private var shouldShowFloatingPlaceholder: Bool {
        return false
    }
    
    // MARK: - Initializer
    public init(
        text: Binding<String>,
        placeholder: String = "",
        errorMessage: String? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.errorMessage = errorMessage
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                HStack {
                    TextField("", text: $text, prompt: inlinePromptText)
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                        .focused($isFocused)
                    
                    if !text.isEmpty && isEditing {
                        Button(action: {
                            text = ""
                        }) {
                            DS.Images.icnPlus
                                .foregroundColor(DS.Colors.Neutral._400)
                                .font(.system(size: 16))
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.bottom, 12)
                .padding(.horizontal, 0)
            }
            .frame(height: 36)
            .background(Color.clear)
            .overlay(
                Rectangle()
                    .frame(height: currentState.borderWidth)
                    .foregroundColor(currentState.borderColor),
                alignment: .bottom
            )
            .animation(.easeInOut(duration: 0.2), value: shouldShowFloatingPlaceholder)
            .animation(.easeInOut(duration: 0.2), value: currentState.borderColor)
            .animation(.easeInOut(duration: 0.2), value: currentState.borderWidth)
            .onChange(of: isFocused) { newValue, oldValue in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isEditing = newValue
                }
            }
            
            if let errorMessage = errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.body2)
                    .foregroundColor(.red)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    // MARK: - Helper
    private var inlinePromptText: Text? {
        if text.isEmpty && !isEditing {
            return Text(placeholder)
                .foregroundColor(DS.Colors.Neutral._400)
        }
        return nil
    }
}
