//
//  DatePickerWithLabelBottomSheet.swift
//  DesignSystem
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct DatePickerWithLabelBottomSheet: View {
    @Binding public var selectedDate: Date
    
    public init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
    }
    
    public var body: some View {
        BottomSheetContainer(height: 400) {
            VStack(spacing: 20) {
                BottomSheetHeader(
                    title: "확인하고 싶은",
                    subtitle: "휴가 날짜를 선택해주세요"
                )
                
                DatePickerBottomSheet(selectedDate: $selectedDate)
            }
        }
    }
}
