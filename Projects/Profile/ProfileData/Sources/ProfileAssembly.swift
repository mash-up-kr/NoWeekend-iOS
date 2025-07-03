//
//  ProfileAssembly.swift
//  ProfileData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Swinject
import ProfileDomain
import Core

public struct ProfileAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("👤 ProfileAssembly 등록 시작")
        
        // Repository 등록
        container.register(UserRepositoryProtocol.self) { _ in
            print("📦 UserRepository 생성")
            return UserRepositoryImpl()
        }.inObjectScope(.container)
        
        // UseCase 등록
        container.register(UserUseCaseProtocol.self) { resolver in
            print("📋 UserUseCase 생성")
            let repository = resolver.resolve(UserRepositoryProtocol.self)!
            return UserUseCase(userRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ ProfileAssembly 등록 완료")
    }
}
