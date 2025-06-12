import Foundation
import Domain

public protocol UserStorageProtocol {
    func saveUser(_ user: User) async throws
    func loadUser() async throws -> User?
    func deleteUser() async throws
}

public protocol EventStorageProtocol {
    func saveEvents(_ events: [Event]) async throws
    func loadEvents() async throws -> [Event]
    func deleteEvent(id: String) async throws
}

public protocol CacheStorageProtocol {
    func store<T: Codable>(_ object: T, forKey key: String) async throws
    func retrieve<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T?
    func remove(forKey key: String) async throws
}
