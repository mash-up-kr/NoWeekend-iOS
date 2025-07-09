//
//  DailySchedule.swift
//  CalendarDomain
//
//  Created by 이지훈 on 7/8/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct DailySchedule: Equatable {
    public let date: String
    public let schedules: [Schedule]
    
    public init(date: String, schedules: [Schedule]) {
        self.date = date
        self.schedules = schedules
    }
}
