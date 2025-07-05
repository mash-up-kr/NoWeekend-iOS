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
