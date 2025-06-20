//
//  SliderBottomSheet.swift
//  DesignSystem
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

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
        BottomSheetContainer(height: 283) {
            VStack(spacing: 40) {
                BottomSheetHeader(
                    title: "평소 휴가는 며칠정도 \n 사용하시나요?",
                    topPadding: 24
                )
                
                VStack(spacing: 32) {
                    CustomSlider(
                        value: $value,
                        range: range,
                        labels: ["1일", "3일", "5일", "7일 이상"]
                    )
                }
            }
        }
    }
}
