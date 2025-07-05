//
//  CalendarUseCaseProtocol.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol CalendarUseCaseProtocol {
    func getCalendarEvents() async throws -> [CalendarEvent]
    func createCalendarEvent(_ event: CalendarEvent) async throws
    func deleteCalendarEvent(id: String) async throws
}
