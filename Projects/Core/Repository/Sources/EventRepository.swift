import Foundation
import RepositoryInterface
import Domain
import NetworkInterface
import StorageInterface

public class EventRepository: EventRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let storage: EventStorageProtocol
    
    public init(
        networkService: NetworkServiceProtocol,
        storage: EventStorageProtocol
    ) {
        self.networkService = networkService
        self.storage = storage
    }
    
    public func getEvents() async throws -> [Event] {
        do {
            let events: [Event] = try await networkService.get(endpoint: "/events", parameters: nil)
            try await storage.saveEvents(events)
            return events
        } catch {
            return try await storage.loadEvents()
        }
    }
    
    public func createEvent(_ event: Event) async throws {
        let _: Event = try await networkService.post(endpoint: "/events", parameters: [
            "title": event.title,
            "date": event.date.timeIntervalSince1970,
            "description": event.description ?? ""
        ])
        
        var events = try await storage.loadEvents()
        events.append(event)
        try await storage.saveEvents(events)
    }
    
    public func deleteEvent(id: String) async throws {
        let _: [String: String] = try await networkService.delete(endpoint: "/events/\(id)")
        try await storage.deleteEvent(id: id)
    }
}
