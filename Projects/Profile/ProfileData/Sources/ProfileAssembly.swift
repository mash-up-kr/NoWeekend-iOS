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
        
        // Repository만 등록 (UseCase는 Feature에서 등록)
        container.register(UserRepositoryProtocol.self) { _ in
            print("📦 UserRepository 생성")
            return UserRepositoryImpl()
        }.inObjectScope(.container)
        
        print("✅ ProfileAssembly 등록 완료")
    }
}
