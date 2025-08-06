//
//  DailySchedule.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct DailySchedule: Equatable, Sendable {
    public let date: String
    public let dailyTemperature: Int
    public let schedules: [Schedule]
    
    public init(date: String, dailyTemperature: Int, schedules: [Schedule]) {
        self.date = date
        self.dailyTemperature = dailyTemperature
        self.schedules = schedules
    }
}
