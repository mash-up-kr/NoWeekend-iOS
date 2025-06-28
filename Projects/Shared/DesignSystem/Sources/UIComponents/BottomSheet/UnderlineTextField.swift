//
//  UnderlineTextField.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct UnderlineTextField: View {
    public let placeholder: String
    @Binding public var text: String
    public let font: Font
    public let textColor: Color
    public let underlineColor: Color
    public let topPadding: CGFloat
    public let bottomPadding: CGFloat
    
    public init(
        placeholder: String,
        text: Binding<String>,
        font: Font = .body1,
        textColor: Color = DS.Colors.Neutral.gray700,
        underlineColor: Color = DS.Colors.Border.border01,
        topPadding: CGFloat = 24,
        bottomPadding: CGFloat = 12
    ) {
        self.placeholder = placeholder
        self._text = text
        self.font = font
        self.textColor = textColor
        self.underlineColor = underlineColor
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .font(font)
            .foregroundStyle(textColor)
            .padding(.top, topPadding)
            .padding(.bottom, bottomPadding)
            .background(
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(underlineColor)
                }
            )
    }
}
