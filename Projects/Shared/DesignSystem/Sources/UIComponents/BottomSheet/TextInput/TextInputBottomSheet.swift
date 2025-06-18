//
//  TextInputBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 텍스트 입력 바텀시트
struct TextInputBottomSheet: View {
    let subtitle: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            VStack(spacing: 24) {
                Text("연차 제목을 작성하면\n할 일에 추가돼요")
                    .font(.heading4)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                
                TextField(placeholder, text: $text)
                    .font(.body1)
                    .foregroundStyle(DS.Colors.Neutral._700)
                    .padding(.top, 24)
                    .padding(.bottom, 12)
                    .background(
                        VStack {
                            Spacer()
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(DS.Colors.Border.gray200)
                        }
                    )
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}
