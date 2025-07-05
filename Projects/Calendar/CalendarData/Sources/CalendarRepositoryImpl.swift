//
//  CalendarRepositoryImpl.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import CalendarDomain
import Core

public final class CalendarRepositoryImpl: CalendarRepositoryProtocol {
    private let mockEvents: [CalendarEvent] = [
        CalendarEvent(
            id: "1", 
            title: "샘플 캘린더 이벤트", 
            startDate: Date(), 
            endDate: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        )
    ]
    
    public init() {}
    
    public func getCalendarEvents() async throws -> [CalendarEvent] {
        try await Task.sleep(nanoseconds: 100_000_000)
        return mockEvents
    }
    
    public func getEventsForDate(_ date: Date) async throws -> [CalendarEvent] {
        return mockEvents.filter { Calendar.current.isDate($0.startDate, inSameDayAs: date) }
    }
    
    public func createCalendarEvent(_ event: CalendarEvent) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
    
    public func updateCalendarEvent(_ event: CalendarEvent) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
    
    public func deleteCalendarEvent(id: String) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
}
