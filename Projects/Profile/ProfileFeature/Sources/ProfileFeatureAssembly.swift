//
//  ProfileFeatureAssembly.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/4/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Core
import Swinject
import ProfileDomain

// MARK: - Assembly (기존 ProfileModuleAssembly 내용을 여기로 이동)
public struct ProfileFeatureAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("👤 ProfileFeatureAssembly 등록 시작")
        
        // UseCase만 등록 (Repository는 Data 모듈에서 등록됨)
        container.register(UserUseCaseProtocol.self) { resolver in
            print("📋 UserUseCase 생성 (Feature)")
            let repository = resolver.resolve(UserRepositoryProtocol.self)!
            return UserUseCase(userRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ ProfileFeatureAssembly 등록 완료")
    }
}
