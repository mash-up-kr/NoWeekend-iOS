//
//  HomeFeatureAssembly.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DIContainer
import Foundation
import HomeDomain
import Swinject

public struct HomeFeatureAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("🏠 HomeFeatureAssembly 등록 시작")
        
        // UseCase만 등록
        container.register(EventUseCaseProtocol.self) { resolver in
            print("📋 EventUseCase 생성 (Feature)")
            let repository = resolver.resolve(EventRepositoryProtocol.self)!
            return EventUseCase(eventRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ HomeFeatureAssembly 등록 완료")
    }
}
