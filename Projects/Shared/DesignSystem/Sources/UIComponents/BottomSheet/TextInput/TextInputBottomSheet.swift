//
//  TextInputBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct TextInputBottomSheet: View {
    public let subtitle: String
    public let placeholder: String
    @Binding public var text: String
    public let onAddButtonTapped: () -> Void
    @Binding public var isPresented: Bool
    
    public init(
        subtitle: String,
        placeholder: String,
        text: Binding<String>,
        isPresented: Binding<Bool>,
        onAddButtonTapped: @escaping () -> Void
    ) {
        self.subtitle = subtitle
        self.placeholder = placeholder
        self._text = text
        self._isPresented = isPresented
        self.onAddButtonTapped = onAddButtonTapped
    }
    
    public var body: some View {
        BottomSheetContainer(height: 300) {
            VStack(spacing: 0) {
                Text(subtitle)
                    .font(.heading4)
                    .foregroundColor(DS.Colors.Text.netural)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 24)
                
                UnderlineTextField(
                    placeholder: placeholder.isEmpty ? "쓸래말래가 추천한 연차 ✈️" : placeholder,
                    text: $text,
                    textColor: DS.Colors.Text.netural
                )
                
                NWButton.black(
                    "추가하기",
                    size: .xl,
                    isEnabled: !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                    action: {
                        onAddButtonTapped()
                    }
                )
                .padding(.top, 48)
            }
        }
    }
}
