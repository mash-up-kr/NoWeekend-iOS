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
    let onDateTap: ((Date) -> Void)?
    let cellContent: (Date) -> Content
    
    private let calendar = Calendar.current
    
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
    
    public init(
        baseDate: Date = Date(),
        onDateTap: ((Date) -> Void)? = nil,
        @ViewBuilder cellContent: @escaping (Date) -> Content
    ) {
        self.baseDate = baseDate
        self.onDateTap = onDateTap
        self.cellContent = cellContent
    }
    
    public var body: some View {
        HStack {
            ForEach(Array(zip(weekdaySymbols.indices, weekdaySymbols)), id: \.0) { index, weekday in
                VStack(spacing: 0) {
                    // 헤더
                    Text(weekday)
                        .font(.body3)
                        .foregroundColor(DS.Colors.Neutral._700)
                        .frame(height: 41)
                    
                    // 날짜
                    Button(action: {
                        onDateTap?(datesInWeek[index])
                    }) {
                        VStack(spacing: 1) {
                            // 날짜 표시
                            ZStack {
                                if index < datesInWeek.count && calendar.isDateInToday(datesInWeek[index]) {
                                    Circle()
                                        .fill(DS.Colors.Toast._100)
                                        .frame(width: 32, height: 32)
                                }
                                
                                if index < datesInWeek.count {
                                    Text("\(calendar.component(.day, from: datesInWeek[index]))")
                                        .font(.subtitle1)
                                        .foregroundColor(calendar.isDateInToday(datesInWeek[index]) ? DS.Colors.Toast._700 : DS.Colors.Neutral._900)
                                }
                            }
                            .frame(height: 41)
                            
                            cellContent(datesInWeek[index])
                                .frame(width: 41, height: 41)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var weekdaySymbols: [String] {
        return ["월", "화", "수", "목", "금", "토", "일"]
    }
}
struct WeekCalendarExampleView: View {
    var body: some View {
        WeekCalendarView { date in
            DS.Images.imgToastVacation
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    WeekCalendarExampleView()
}
