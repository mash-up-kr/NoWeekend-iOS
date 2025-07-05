//
//  ProfileDataModule.swift
//  ProfileData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import DIContainer
import ProfileDomain

public enum ProfileDataModule {
    public static func registerRepositories() {
        print("👤 ProfileData Repository 등록")
        
        // Domain Protocol을 Data 모듈에서 등록
        DIContainer.shared.container.register(UserRepositoryProtocol.self) { _ in
            return UserRepositoryImpl()
        }.inObjectScope(.container)
        
        print("✅ ProfileData Repository 등록 완료")
    }
}
