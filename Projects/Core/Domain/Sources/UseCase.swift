import Foundation

// MARK: - User UseCase
public protocol GetUserUseCaseProtocol {
    func execute() async throws -> User
}

public protocol UpdateUserUseCaseProtocol {
    func execute(_ user: User) async throws
}

// MARK: - Event UseCase
public protocol GetEventsUseCaseProtocol {
    func execute() async throws -> [Event]
}

public protocol CreateEventUseCaseProtocol {
    func execute(_ event: Event) async throws
}
