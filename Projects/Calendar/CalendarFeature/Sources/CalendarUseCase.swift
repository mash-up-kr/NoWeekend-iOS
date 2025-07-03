//
//  CalendarUseCase.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import CalendarDomain

public class CalendarUseCase: CalendarUseCaseProtocol {
    private let calendarRepository: CalendarRepositoryProtocol
    
    public init(calendarRepository: CalendarRepositoryProtocol) {
        self.calendarRepository = calendarRepository
    }
    
    public func getCalendarEvents() async throws -> [CalendarEvent] {
        return try await calendarRepository.getCalendarEvents()
    }
    
    public func getEventsForDate(_ date: Date) async throws -> [CalendarEvent] {
        return try await calendarRepository.getEventsForDate(date)
    }
    
    public func createCalendarEvent(_ event: CalendarEvent) async throws {
        try await calendarRepository.createCalendarEvent(event)
    }
    
    public func updateCalendarEvent(_ event: CalendarEvent) async throws {
        try await calendarRepository.updateCalendarEvent(event)
    }
    
    public func deleteCalendarEvent(id: String) async throws {
        try await calendarRepository.deleteCalendarEvent(id: id)
    }
}
