import Foundation
import SwiftUI

// MARK: - Date Extensions
public extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// MARK: - String Extensions
public extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

// MARK: - Color Extensions
public extension Color {
    static let primary = Color("Primary")
    static let secondary = Color("Secondary")
    static let background = Color("Background")
}
