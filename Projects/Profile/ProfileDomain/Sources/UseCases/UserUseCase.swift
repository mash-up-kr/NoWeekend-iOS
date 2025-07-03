//
//  UserUseCase.swift
//  ProfileDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol UserUseCaseProtocol {
    func getCurrentUser() async throws -> User
    func updateUserProfile(name: String, email: String) async throws -> User
    func updateUserPreferences(_ preferences: UserPreferences) async throws
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
        let updatedUser = User(
            id: currentUser.id,
            name: name,
            email: email,
            preferences: currentUser.preferences
        )
        try await userRepository.updateUser(updatedUser)
        return updatedUser
    }
    
    public func updateUserPreferences(_ preferences: UserPreferences) async throws {
        try await userRepository.updateUserPreferences(preferences)
    }
}
