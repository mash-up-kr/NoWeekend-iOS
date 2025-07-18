//
//  SandwichHolidayDTO.swift
//  HomeData
//
//  Created by 김나희 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import HomeDomain

public struct SandwichHolidayResponseDTO: Codable {
    public let result: String
    public let data: SandwichHolidayDataDTO?
    public let error: String?
    
    public init(result: String, data: SandwichHolidayDataDTO?, error: String?) {
        self.result = result
        self.data = data
        self.error = error
    }
}

public struct SandwichHolidayDataDTO: Codable {
    public let responses: [SandwichHolidayItemDTO]
    
    public init(responses: [SandwichHolidayItemDTO]) {
        self.responses = responses
    }
    
    public func toDomain() -> [SandwichHoliday] {
        return responses.compactMap { $0.toDomain() }
    }
}

public struct SandwichHolidayItemDTO: Codable {
    public let startDate: String
    public let endDate: String
    public let useAnnualLeave: Int
    public let totalVacationDays: Int
    
    public init(startDate: String, endDate: String, useAnnualLeave: Int, totalVacationDays: Int) {
        self.startDate = startDate
        self.endDate = endDate
        self.useAnnualLeave = useAnnualLeave
        self.totalVacationDays = totalVacationDays
    }
    
    public func toDomain() -> SandwichHoliday? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: startDate),
              let endDate = dateFormatter.date(from: endDate) else {
            return nil
        }
        
        return SandwichHoliday(
            startDate: startDate,
            endDate: endDate,
            useAnnualLeave: useAnnualLeave,
            totalVacationDays: totalVacationDays
        )
    }
} 