//
//  LeaveRequestDTO.swift
//  Network
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct LeaveRequestDTO {
    public let days: Int
    public let hours: Int
    
    public init(days: Int, hours: Int) {
        self.days = days
        self.hours = hours
    }
    
    public var toDictionary: [String: Any] {
        return [
            "days": days,
            "hours": hours
        ]
    }
}
