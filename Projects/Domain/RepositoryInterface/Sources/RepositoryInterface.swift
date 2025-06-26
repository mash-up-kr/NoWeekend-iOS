import Foundation
import Entity

// MARK: - User Repository Protocol
public protocol UserRepositoryProtocol {
    func getCurrentUser() async throws -> User
    func updateUser(_ user: User) async throws
}

// MARK: - Event Repository Protocol  
public protocol EventRepositoryProtocol {
    func getEvents() async throws -> [Event]
    func createEvent(_ event: Event) async throws
    func deleteEvent(id: String) async throws
}
