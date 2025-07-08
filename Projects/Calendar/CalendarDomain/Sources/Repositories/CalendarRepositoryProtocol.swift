//
//  CalendarRepositoryProtocol.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol CalendarRepositoryProtocol {
    func getSchedules(startDate: String, endDate: String) async throws -> [DailySchedule]
}
