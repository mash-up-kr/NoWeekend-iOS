import Foundation
import SwiftUI
import Entity

// MARK: - Calendar Builder Protocol
public protocol CalendarBuilder {
    func makeCalendarView() -> AnyView
}
