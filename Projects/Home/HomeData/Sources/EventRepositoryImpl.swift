//
//  EventRepositoryImpl.swift
//  HomeData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import HomeDomain
import DIContainer

public final class EventRepositoryImpl: EventRepositoryProtocol {
    private let mockEvents: [Event] = [
        Event(id: "1", title: "샘플 이벤트", date: Date())
    ]
    
    public init() {}
    
    public func getEvents() async throws -> [Event] {
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1초
        return mockEvents
    }
    
    public func createEvent(_ event: Event) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
    
    public func deleteEvent(id: String) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
}
