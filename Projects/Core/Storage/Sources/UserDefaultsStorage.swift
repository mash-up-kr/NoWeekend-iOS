import Foundation
import StorageInterface
import Domain
import Common

public class UserDefaultsStorage: UserStorageProtocol, EventStorageProtocol {
    private let userDefaults = UserDefaults.standard
    private let userKey = "saved_user"
    private let eventsKey = "saved_events"
    
    public init() {}
    
    public func saveUser(_ user: User) async throws {
        let data = try JSONEncoder().encode(user)
        userDefaults.set(data, forKey: userKey)
    }
    
    public func loadUser() async throws -> User? {
        guard let data = userDefaults.data(forKey: userKey) else { return nil }
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    public func deleteUser() async throws {
        userDefaults.removeObject(forKey: userKey)
    }
    
    public func saveEvents(_ events: [Event]) async throws {
        let data = try JSONEncoder().encode(events)
        userDefaults.set(data, forKey: eventsKey)
    }
    
    public func loadEvents() async throws -> [Event] {
        guard let data = userDefaults.data(forKey: eventsKey) else { return [] }
        return try JSONDecoder().decode([Event].self, from: data)
    }
    
    public func deleteEvent(id: String) async throws {
        var events = try await loadEvents()
        events.removeAll { $0.id == id }
        try await saveEvents(events)
    }
}
