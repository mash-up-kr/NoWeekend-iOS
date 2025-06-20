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
    
    public init(
        subtitle: String,
        placeholder: String,
        text: Binding<String>
    ) {
        self.subtitle = subtitle
        self.placeholder = placeholder
        self._text = text
    }
    
    public var body: some View {
        BottomSheetContainer(height: 200) {
            VStack(spacing: 24) {
                Text("연차 제목을 작성하면\n할 일에 추가돼요")
                    .font(.heading4)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                
                UnderlineTextField(
                    placeholder: placeholder,
                    text: $text
                )
            }
        }
    }
}
