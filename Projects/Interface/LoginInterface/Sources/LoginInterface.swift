import SwiftUI
import Domain

public protocol LoginInterfaceProtocol: ObservableObject {
    var events: [Event] { get }
    var selectedDate: Date { get set }
    var isLoading: Bool { get }
    
    func loadEvents(for date: Date) async
    func selectDate(_ date: Date) async
}
