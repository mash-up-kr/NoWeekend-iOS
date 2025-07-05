//
//  UserRepositoryImpl.swift
//  ProfileData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import ProfileDomain

public final class UserRepositoryImpl: UserRepositoryProtocol {
    private let mockUser = User(id: "1", name: "나희", email: "nahee@noweekend.com")
    
    public init() {}
    
    public func getCurrentUser() async throws -> User {
        try await Task.sleep(nanoseconds: 100_000_000)
        return mockUser
    }
    
    public func updateUser(_ user: User) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
    
    public func updateUserPreferences(_ preferences: UserPreferences) async throws {
        try await Task.sleep(nanoseconds: 100_000_000)
    }
}
