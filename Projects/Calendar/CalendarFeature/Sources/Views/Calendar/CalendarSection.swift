//
//  CalendarSection.swift
//  Feature
//
//  Created by 이지훈 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct CalendarSection: View {
    let selectedDate: Date
    let selectedToggle: CalendarNavigationBar.ToggleOption
    let onDateTap: (Date) -> Void
    let calendarCellContent: (Date) -> AnyView
    
    init(
        selectedDate: Date,
        selectedToggle: CalendarNavigationBar.ToggleOption,
        onDateTap: @escaping (Date) -> Void,
        calendarCellContent: @escaping (Date) -> some View
    ) {
        self.selectedDate = selectedDate
        self.selectedToggle = selectedToggle
        self.onDateTap = onDateTap
        self.calendarCellContent = { date in AnyView(calendarCellContent(date)) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selectedToggle {
                case .week:
                    WeekCalendarView(
                        baseDate: selectedDate,
                        onDateTap: onDateTap
                    ) { date in
                        calendarCellContent(date)
                    }
                    
                case .month:
                    MonthCalendarView(
                        selectedDate: selectedDate,
                        onDateTap: onDateTap,
                        calendarCellContent: { date in calendarCellContent(date) }
                    )
                }
            }
            
            if selectedToggle == .week {
                Rectangle()
                    .fill(DS.Colors.Neutral.gray100)
                    .frame(height: 8)
                    .padding(.top, 12)
            }
        }
    }
}
