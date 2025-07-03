//
//  EventUseCaseProtocol.swift
//  HomeDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol EventUseCaseProtocol {
    func getEvents() async throws -> [Event]
    func createEvent(title: String, date: Date, description: String?) async throws
    func deleteEvent(id: String) async throws
    func getUpcomingEvents() async throws -> [Event]
}

public class EventUseCase: EventUseCaseProtocol {
    private let eventRepository: EventRepositoryProtocol
    
    public init(eventRepository: EventRepositoryProtocol) {
        self.eventRepository = eventRepository
    }
    
    public func getEvents() async throws -> [Event] {
        return try await eventRepository.getEvents()
    }
    
    public func createEvent(title: String, date: Date, description: String?) async throws {
        let event = Event(
            id: UUID().uuidString,
            title: title,
            date: date,
            description: description
        )
        try await eventRepository.createEvent(event)
    }
    
    public func deleteEvent(id: String) async throws {
        try await eventRepository.deleteEvent(id: id)
    }
    
    public func getUpcomingEvents() async throws -> [Event] {
        let allEvents = try await eventRepository.getEvents()
        let now = Date()
        return allEvents.filter { $0.date > now }.sorted { $0.date < $1.date }
    }
}
