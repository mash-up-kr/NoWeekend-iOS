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
    
    private let calendar = Calendar.current
    
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
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 8) {
            ForEach(datesInMonth, id: \.self) { date in
                monthCell(for: date)
            }
        }
    }
    
    @ViewBuilder
    private func monthCell(for date: Date) -> some View {
        let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
        let isToday = calendar.isDateInToday(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        
        if isCurrentMonth {
            Button(action: {
                onDateTap(date)
            }) {
                VStack(spacing: 1) {
                    ZStack {
                        if isSelected {
                            // 선택된 날짜에만 circle 표시
                            Circle()
                                .fill(DS.Colors.Toast._100)
                                .frame(width: 32, height: 32)
                        }
                        
                        Text("\(calendar.component(.day, from: date))")
                            .font(.subtitle1)
                            .foregroundStyle(
                                isSelected ? DS.Colors.Toast._700 :
                                (isToday ? DS.Colors.Toast._700 : DS.Colors.Text.netural)
                            )
                    }
                    .frame(height: 41)
                    
                    calendarCellContent(date)
                        .frame(height: 41)
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
