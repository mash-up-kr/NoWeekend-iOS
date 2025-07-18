import Foundation
import SwiftUI

// MARK: - Date Extensions
public extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
    
    func toISO8601String() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
    
    // 한국어 로케일 날짜 포맷 메서드들
    func toKoreanFormat(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        return formatter.string(from: self)
    }
    
    func toMonthString() -> String {
        return toKoreanFormat("M")
    }
    
    func toMonthDayString() -> String {
        return toKoreanFormat("M/dd")
    }
    
    func toMonthDayWeekString() -> String {
        return toKoreanFormat("M/dd(E)")
    }
    
    func toMonthName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        return formatter.monthSymbols[month - 1]
    }
}

// MARK: - String Extensions
public extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current
        return formatter.date(from: self)
    }
    
    func toDateFromISO8601() -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self)
    }
}
