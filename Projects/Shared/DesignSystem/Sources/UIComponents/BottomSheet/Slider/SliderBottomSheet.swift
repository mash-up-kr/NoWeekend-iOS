//
//  SliderBottomSheet.swift
//  DesignSystem
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 슬라이더 바텀시트
public struct SliderBottomSheet: View {
    public let title: String
    @Binding public var value: Double
    public let range: ClosedRange<Double>
    public let unit: String
    
    public init(
        title: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        unit: String
    ) {
        self.title = title
        self._value = value
        self.range = range
        self.unit = unit
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            VStack(spacing: 40) {
                Text("평소 휴가는 며칠정도 \n 사용하시나요?")
                    .font(.title3) // TODO: 폰트수정
                    .foregroundColor(.primary) // TODO: 색상수정
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
