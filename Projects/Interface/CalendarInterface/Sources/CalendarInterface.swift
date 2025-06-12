import SwiftUI
import Domain

public protocol CalendarProtocol: ObservableObject {
    var events: [Event] { get }
    var selectedDate: Date { get set }
    var isLoading: Bool { get }
    
    func loadEvents(for date: Date) async
    func selectDate(_ date: Date) async
}

public protocol CalendarCoordinatorProtocol {
    func navigateToEventDetail(_ event: Event)
    func navigateToCreateEvent(for date: Date)
}
