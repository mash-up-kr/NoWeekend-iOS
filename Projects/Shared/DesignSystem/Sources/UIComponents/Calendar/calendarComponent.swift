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
    
    @State private var datesInWeek: [Date] = []
    
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
        VStack(spacing: 0) {
            weekdayHeader
            weekGrid
        }
        .padding(.horizontal, 20)
        .onAppear {
            if datesInWeek.isEmpty {
                calculateDatesInWeek()
            }
        }
        .onChange(of: baseDate) { _, _ in
            calculateDatesInWeek()
        }
    }
    
    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .font(.body3)
                    .foregroundColor(DS.Colors.Neutral._700)
                    .frame(width: 41, height: 41)
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
                            if calendar.isDateInToday(date) {
                                Circle()
                                    .fill(DS.Colors.Toast._100)
                                    .frame(width: 32, height: 32)
                            }
                            
                            Text("\(calendar.component(.day, from: date))")
                                .font(.subtitle2)
                                .foregroundColor(calendar.isDateInToday(date) ? DS.Colors.Toast._700 : DS.Colors.Neutral._900)
                        }
                        .frame(width: 41, height: 41)
                        cellContent(date)
                            .frame(width: 41, height: 41)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    private var weekdaySymbols: [String] {
        return ["월", "화", "수", "목", "금", "토", "일"]
    }
    
    private func calculateDatesInWeek() {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: baseDate) else {
            datesInWeek = []
            return
        }
        
        var dates: [Date] = []
        var date = weekInterval.start
        
        for _ in 0..<7 {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date) ?? date
        }
        
        datesInWeek = dates
    }
}

struct WeekCalendarExampleView: View {
    var body: some View {
        WeekCalendarView { date in
            DS.Images.imgToastVacation
                .resizable()
                .scaledToFit()
                .frame(width: 38)
        }
    }
}

#Preview {
    WeekCalendarExampleView()
}
