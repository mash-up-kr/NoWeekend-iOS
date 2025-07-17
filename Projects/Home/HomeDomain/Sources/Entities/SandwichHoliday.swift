//
//  SandwichHoliday.swift
//  HomeDomain
//
//  Created by 김나희 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public struct SandwichHoliday: Equatable, DateStringConvertible {
    public let startDate: Date
    public let endDate: Date
    public let useAnnualLeave: Int
    public let totalVacationDays: Int
    
    public init(startDate: Date, endDate: Date, useAnnualLeave: Int, totalVacationDays: Int) {
        self.startDate = startDate
        self.endDate = endDate
        self.useAnnualLeave = useAnnualLeave
        self.totalVacationDays = totalVacationDays
    }
    
    public var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M/dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let startString = dateFormatter.string(from: startDate)
        let endString = dateFormatter.string(from: endDate)
        
        return "\(startString) ~ \(endString)"
    }
    
    public var vacationText: String {
        return "연차 \(useAnnualLeave)일로\n\(totalVacationDays)일 쉴 수 있어요!"
    }
} 
