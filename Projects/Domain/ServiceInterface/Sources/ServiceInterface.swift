import Foundation

// MARK: - Network Service Protocol
public protocol NetworkServiceProtocol {
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func post<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func put<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func delete<T: Decodable>(endpoint: String) async throws -> T
}

// MARK: - Storage Protocols
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