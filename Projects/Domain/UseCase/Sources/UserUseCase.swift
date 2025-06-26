import Foundation
import Entity
import RepositoryInterface

public protocol UserUseCaseProtocol {
    func getCurrentUser() async throws -> User
    func updateUserProfile(name: String, email: String) async throws -> User
}

public class UserUseCase: UserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func getCurrentUser() async throws -> User {
        return try await userRepository.getCurrentUser()
    }
    
    public func updateUserProfile(name: String, email: String) async throws -> User {
        let currentUser = try await userRepository.getCurrentUser()
        let updatedUser = User(id: currentUser.id, name: name, email: email)
        try await userRepository.updateUser(updatedUser)
        return updatedUser
    }
}
