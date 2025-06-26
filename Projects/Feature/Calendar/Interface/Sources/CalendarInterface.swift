import Foundation
import SwiftUI
import NeedleFoundation
import Entity

// MARK: - Calendar Dependency Protocol
public protocol CalendarDependency: Dependency {
    // var eventUseCase: EventUseCase { get }
}

// MARK: - Calendar Builder Protocol
public protocol CalendarBuilder {
    func makeCalendarView() -> AnyView
}
