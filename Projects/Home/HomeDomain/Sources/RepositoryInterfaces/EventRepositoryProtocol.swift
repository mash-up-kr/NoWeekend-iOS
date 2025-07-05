//
//  EventRepositoryProtocol.swift
//  HomeDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol EventRepositoryProtocol {
    func getEvents() async throws -> [Event]
    func createEvent(_ event: Event) async throws
    func deleteEvent(id: String) async throws
}
