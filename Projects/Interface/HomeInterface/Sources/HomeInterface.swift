import SwiftUI
import Domain

public protocol HomeProtocol: ObservableObject {
    var events: [Event] { get }
    var isLoading: Bool { get }
    
    func loadEvents() async
    func refreshEvents() async
}

public protocol HomeCoordinatorProtocol {
    func navigateToEventDetail(_ event: Event)
    func navigateToCreateEvent()
}
