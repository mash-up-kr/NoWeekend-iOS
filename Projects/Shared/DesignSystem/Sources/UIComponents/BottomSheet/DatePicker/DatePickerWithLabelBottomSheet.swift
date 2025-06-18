//
//  DatePickerWithLabelBottomSheet.swift
//  DesignSystem
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 레이블이 있는 날짜 선택 바텀시트
public struct DatePickerWithLabelBottomSheet: View {
    @Binding public var selectedDate: Date
    
    public init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            VStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("확인하고 싶은")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("휴가 날짜를 선택해주세요")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .multilineTextAlignment(.center)
                
                DatePickerBottomSheet(selectedDate: $selectedDate)
            }
            .padding(.horizontal, 20)
        }
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}
