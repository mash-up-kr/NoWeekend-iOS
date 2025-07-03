//
//  UserRepositoryImpl.swift
//  ProfileData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import ProfileDomain
import Core

public final class UserRepositoryImpl: UserRepositoryProtocol {
    private let realUserDatabase: [User] = [
        User(id: "user_001", name: "이지훈", email: "jihoon@company.com"),
        User(id: "user_002", name: "김나희", email: "nahee@company.com"),
        User(id: "user_003", name: "박개발", email: "dev@company.com"),
        User(id: "user_004", name: "최디자인", email: "design@company.com")
    ]
    
    private var currentUserId: String = "user_002"
    
    public init() {
        print("👤 UserRepositoryImpl 생성")
    }
    
    public func getCurrentUser() async throws -> User {
        print("👤 현재 사용자 조회 API 호출")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000)
        
        guard let user = realUserDatabase.first(where: { $0.id == currentUserId }) else {
            throw UserError.userNotFound
        }
        
        print("✅ 사용자 조회 성공: \(user.name)")
        return user
    }
    
    public func updateUser(_ user: User) async throws {
        print("💾 사용자 정보 업데이트 API 호출: \(user.name)")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        print("✅ 사용자 정보 업데이트 완료")
    }
    
    public func updateUserPreferences(_ preferences: UserPreferences) async throws {
        print("⚙️ 사용자 설정 업데이트 API 호출")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000)
        
        print("✅ 사용자 설정 업데이트 완료")
    }
}

// MARK: - User Error
enum UserError: Error, LocalizedError {
    case userNotFound
    case updateFailed
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .updateFailed:
            return "사용자 정보 업데이트에 실패했습니다."
        }
    }
}
