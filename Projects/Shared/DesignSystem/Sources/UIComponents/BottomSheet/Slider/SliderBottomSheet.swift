//
//  SliderBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 슬라이더 바텀시트
struct SliderBottomSheet: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let unit: String
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            VStack(spacing: 40) {
                Text("평소 휴가는 며칠정도 \n 사용하시나요?")
                    .font(.heading4)
                    .foregroundColor(DS.Colors.Neutral._900) // TODO: 색상수정
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                
                VStack(spacing: 32) {
                    CustomSlider(
                        value: $value,
                        range: range,
                        labels: ["1일", "3일", "5일", "7일 이상"]
                    )
                }
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .presentationDetents([.height(283)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}
