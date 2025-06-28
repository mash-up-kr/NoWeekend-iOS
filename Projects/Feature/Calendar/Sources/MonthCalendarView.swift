//
//  MonthCalendarView.swift
//  Feature
//
//  Created by 이지훈 on 6/29/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

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
        guard let firstDayOfWeek = calendar.dateInterval(of: .weekOfYear, for: firstDayOfMonth)?.start else {
            return []
        }
        
        var dates: [Date] = []
        var currentDate = firstDayOfWeek
        
        // 5주치 날짜
        for _ in 0..<35 {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    private var weekdaySymbols: [String] {
        return ["월", "화", "수", "목", "금", "토", "일"]
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
                    .foregroundStyle(DS.Colors.Text.gray700)
                    .frame(maxWidth: .infinity)
                    .frame(height: 41)
            }
        }
    }
    
    private var monthGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
            ForEach(datesInMonth, id: \.self) { date in
                monthCell(for: date)
            }
        }
    }
    
    @ViewBuilder
    private func monthCell(for date: Date) -> some View {
        let isCurrentMonth = calendar.isDate(date, equalTo: selectedDate, toGranularity: .month)
        let isToday = calendar.isDateInToday(date)
        var isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        
        if isCurrentMonth {
            Button(action: {
                onDateTap(date)
            }) {
                VStack(spacing: 0) {
                    ZStack {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.subtitle1)
                            .foregroundStyle(isToday ? DS.Colors.Toast._700 : DS.Colors.Neutral._900)
                    }
                    .frame(height: 41)
                    
                    calendarCellContent(date)
                        .frame(width: 41, height: 41)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 82)
        } else {
            // 다른 달 날짜는 표시하지 않음
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 84)
        }
    }
    
    private func dayTextColor(isCurrentMonth: Bool, isToday: Bool) -> Color {
        if isToday {
            return DS.Colors.Toast._700
        } else if isCurrentMonth {
            return DS.Colors.Neutral._900
        } else {
            return DS.Colors.Neutral._400
        }
    }
}


#Preview {
    MonthCalendarView(
        selectedDate: Date(),
        onDateTap: { _ in },
        calendarCellContent: { date in
            DS.Images.imgToastVacation
                .resizable()
                .scaledToFit()
        }
    )
}
