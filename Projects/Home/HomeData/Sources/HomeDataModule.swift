//
//  HomeDataModule.swift
//  HomeData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core
import HomeDomain

public enum HomeDataModule {
    public static func registerRepositories() {
        print("🏠 HomeData Repository 등록")
        
        // Domain Protocol을 Data 모듈에서 등록
        DIContainer.shared.container.register(EventRepositoryProtocol.self) { _ in
            return EventRepositoryImpl()
        }.inObjectScope(.container)
        
        print("✅ HomeData Repository 등록 완료")
    }
}
