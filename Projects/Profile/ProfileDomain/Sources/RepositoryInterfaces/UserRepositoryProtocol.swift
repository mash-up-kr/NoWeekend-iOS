//
//  UserRepositoryProtocol.swift
//  ProfileDomain
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public protocol UserRepositoryProtocol {
    func getCurrentUser() async throws -> User
    func updateUser(_ user: User) async throws
    func updateUserPreferences(_ preferences: UserPreferences) async throws
}
