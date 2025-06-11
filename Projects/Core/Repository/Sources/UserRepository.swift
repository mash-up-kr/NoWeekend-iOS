import Foundation
import RepositoryInterface
import Domain
import NetworkInterface
import StorageInterface

public class UserRepository: UserRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let storage: UserStorageProtocol
    
    public init(
        networkService: NetworkServiceProtocol,
        storage: UserStorageProtocol
    ) {
        self.networkService = networkService
        self.storage = storage
    }
    
    public func getCurrentUser() async throws -> User {
        if let cachedUser = try await storage.loadUser() {
            return cachedUser
        }
        
        let user: User = try await networkService.get(endpoint: "/user/me", parameters: nil)
        try await storage.saveUser(user)
        return user
    }
    
    public func updateUser(_ user: User) async throws {
        let _: User = try await networkService.put(endpoint: "/user/\(user.id)", parameters: [
            "name": user.name,
            "email": user.email
        ])
        
        try await storage.saveUser(user)
    }
}
