//
//  calendarComponent.swift
//  DesignSystem
//
//  Created by 이지훈 on 6/23/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct WeekCalendarView<Content: View>: View {
    let baseDate: Date
    let selectedDate: Date
    let onDateTap: ((Date) -> Void)?
    let cellContent: (Date) -> Content
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2  
        return cal
    }
    
    private var datesInWeek: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: baseDate) else {
            return []
        }
        
        var dates: [Date] = []
        var date = weekInterval.start
        
        for _ in 0..<7 {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        return dates
    }
    
    private var weekdaySymbols: [String] {
        ["월", "화", "수", "목", "금", "토", "일"]
    }
    
    public init(
        baseDate: Date = Date(),
        selectedDate: Date = Date(),
        onDateTap: ((Date) -> Void)? = nil,
        @ViewBuilder cellContent: @escaping (Date) -> Content
    ) {
        self.baseDate = baseDate
        self.selectedDate = selectedDate
        self.onDateTap = onDateTap
        self.cellContent = cellContent
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            weekdayHeader
            weekGrid
        }
        .padding(.horizontal, 20)
    }
    
    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(.body3)
                    .foregroundColor(DS.Colors.Neutral.gray700)
                    .frame(height: 41)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var weekGrid: some View {
        HStack(spacing: 0) {
            ForEach(datesInWeek, id: \.self) { date in
                Button(action: {
                    onDateTap?(date)
                }) {
                    VStack(spacing: 1) {
                        ZStack {
                            if calendar.isDate(date, inSameDayAs: selectedDate) {
                                Circle()
                                    .fill(DS.Colors.Toast._100)
                                    .frame(width: 32, height: 32)
                            }
                            
                            Text("\(calendar.component(.day, from: date))")
                                .font(.subtitle2)
                                .foregroundColor(
                                    calendar.isDate(date, inSameDayAs: selectedDate) ? .white :
                                    (calendar.isDateInToday(date) ? DS.Colors.Toast._700 : DS.Colors.Text.netural)
                                )
                        }
                        .frame(height: 41)
                        
                        cellContent(date)
                            .frame(height: 41)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 80)
            }
        }
    }
}
