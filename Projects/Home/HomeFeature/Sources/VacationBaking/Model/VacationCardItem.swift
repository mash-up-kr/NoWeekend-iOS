//
//  VacationCardItem.swift
//  HomeFeature
//
//  Created by 김나희 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import SwiftUI
import DesignSystem
import HomeDomain

struct VacationCardItem: Equatable {
    let dateString: String
    let type: VacationCardType
    let sandwichHoliday: SandwichHoliday?
    
    init(dateString: String, type: VacationCardType, sandwichHoliday: SandwichHoliday? = nil) {
        self.dateString = dateString
        self.type = type
        self.sandwichHoliday = sandwichHoliday
    }
    
    var attributedText: AttributedString? {
        type.createAttributedText(dateString: dateString, sandwichHoliday: sandwichHoliday)
    }
}

// MARK: - VacationCardType AttributedText Extension
extension VacationCardType {
    func createAttributedText(dateString: String, sandwichHoliday: SandwichHoliday? = nil) -> AttributedString? {
        switch self {
        case .sandwich:
            return createSandwichAttributedText(dateString: dateString, sandwichHoliday: sandwichHoliday)
        case .holiday:
            return createHolidayAttributedText()
        case .birthday:
            return createBirthdayAttributedText()
        default:
            return attributedText
        }
    }
    
    private func createSandwichAttributedText(dateString: String, sandwichHoliday: SandwichHoliday?) -> AttributedString {
        if let sandwichHoliday = sandwichHoliday {
            var str = AttributedString(sandwichHoliday.vacationText)
            
            if let range = str.range(of: "\(sandwichHoliday.useAnnualLeave)일") {
                str[range].foregroundColor = DS.Colors.Toast._500
            }
            
            if let range = str.range(of: "\(sandwichHoliday.totalVacationDays)일") {
                str[range].foregroundColor = DS.Colors.Toast._500
            }
            
            return str
        } else {
            let days = dateString.calculateDaysBetweenDates()
            var str = AttributedString("샌드위치 연휴로 \(days)일 쉴 수 있어요")
            if let range = str.range(of: "\(days)일") {
                str[range].foregroundColor = DS.Colors.Toast._500
            }
            return str
        }
    }
    
    private func createHolidayAttributedText() -> AttributedString {
        var str = AttributedString("곧 공휴일이 다가와요")
        if let range = str.range(of: "공휴일") {
            str[range].foregroundColor = DS.Colors.Toast._500
        }
        return str
    }
    
    private func createBirthdayAttributedText() -> AttributedString {
        var str = AttributedString("생일\n축하드려요!")
        if let range = str.range(of: "생일") {
            str[range].foregroundColor = DS.Colors.Toast._500
        }
        return str
    }
}

// MARK: - String Date Calculation Extension
extension String {
    func calculateDaysBetweenDates() -> Int {
        let components = self.components(separatedBy: " ~ ")
        guard components.count == 2 else { return 1 }
        
        let startDay = components[0].extractDay()
        let endDay = components[1].extractDay()
        
        return max(1, endDay - startDay + 1)
    }
    
    private func extractDay() -> Int {
        let components = self.components(separatedBy: "/")
        guard components.count == 2 else { return 1 }
        
        let dayComponent = components[1].components(separatedBy: "(")[0]
        return Int(dayComponent) ?? 1
    }
}

enum VacationCardType: CaseIterable, Hashable {
    
    enum ViewType {
        case long
        case short
    }

    case monday, birthday, holiday, sandwich, noholiday, friday
    case trip, good, home, koreaTrip

    var viewType: ViewType {
        switch self {
        case .trip, .good, .home, .koreaTrip:
            return .long
        default:
            return .short
        }
    }
}
