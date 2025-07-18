//
//  MonthCalendarView.swift
//  Feature
//
//  Created by 이지훈 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DesignSystem
import SwiftUI

struct MonthCalendarView: View {
    let selectedDate: Date
    let onDateTap: (Date) -> Void
    let calendarCellContent: (Date) -> AnyView
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }
    
    private var datesInMonth: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else {
            return []
        }
        
        let firstDayOfMonth = monthInterval.start
        let lastDayOfMonth = monthInterval.end
        
        guard let firstDayOfWeek = calendar.dateInterval(of: .weekOfYear, for: firstDayOfMonth)?.start else {
            return []
        }
        
        guard let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: lastDayOfMonth),
              let lastDayOfWeek = calendar.date(byAdding: .day, value: -1, to: lastWeekInterval.end) else {
            return []
        }
        
        var dates: [Date] = []
        var currentDate = firstDayOfWeek
        
        while currentDate <= lastDayOfWeek {
            dates.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return dates
    }
    
    private var weekdaySymbols: [String] {
        ["월", "화", "수", "목", "금", "토", "일"]
    }
    
    init(
        selectedDate: Date,
        onDateTap: @escaping (Date) -> Void,
        calendarCellContent: @escaping (Date) -> some View
    ) {
        self.selectedDate = selectedDate
        self.onDateTap = onDateTap
        self.calendarCellContent = { date in AnyView(calendarCellContent(date)) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            weekdayHeader
            monthGrid
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
    
    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(.body3)
                    .foregroundStyle(DS.Colors.Text.netural)
                    .frame(maxWidth: .infinity)
                    .frame(height: 41)
            }
        }
    }
    
    private var monthGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
            ForEach(datesInMonth, id: \.self) { date in
                monthCell(for: date)
            }
        }
    }
    
    @ViewBuilder
    private func monthCell(for date: Date) -> some View {
        let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        
        if isCurrentMonth {
            Button(action: {
                onDateTap(date)
            }) {
                VStack(spacing: 1) {
                    ZStack {
                        // 서클은 오직 선택된 날짜에만 표시
                        if isSelected {
                            Circle()
                                .fill(DS.Colors.Toast._100)
                                .frame(width: 32, height: 32)
                        }
                        
                        Text("\(calendar.component(.day, from: date))")
                            .font(.subtitle2)
                            .foregroundColor(textColor(for: date))
                    }
                    .frame(height: 41)
                    
                    calendarCellContent(date)
                        .frame(width: 41, height: 41)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
        } else {
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 90)
        }
    }
    
    private func textColor(for date: Date) -> Color {
        let isToday = calendar.isDateInToday(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
        
        if isSelected && isToday {
            return DS.Colors.Toast._700
        } else if isSelected {
            return .black
        } else if isToday {
            return DS.Colors.Toast._700
        } else if !isCurrentMonth {
            return DS.Colors.Text.disable
        } else {
            return DS.Colors.Text.netural
        }
    }
}

#Preview {
    MonthCalendarView(
        selectedDate: Date(),
        onDateTap: { _ in },
        calendarCellContent: { _ in
            DS.Images.imgToastVacation
                .resizable()
                .scaledToFit()
        }
    )
}
