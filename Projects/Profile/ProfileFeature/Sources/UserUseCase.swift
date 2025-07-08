//
//  UserUseCase.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import ProfileDomain

public class UserUseCase: UserUseCaseProtocol {
    private let userRepository: UserRepositoryProtocol
    
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func getCurrentUser() async throws -> User {
        try await userRepository.getCurrentUser()
    }
    
    public func updateUser(_ user: User) async throws {
        try await userRepository.updateUser(user)
    }
}
