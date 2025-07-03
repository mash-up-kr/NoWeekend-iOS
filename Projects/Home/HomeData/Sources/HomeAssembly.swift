//
//  HomeAssembly.swift
//  HomeData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Swinject
import HomeDomain
import Core

public struct HomeAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("🏠 HomeAssembly 등록 시작")
        
        // Repository 등록
        container.register(EventRepositoryProtocol.self) { _ in
            print("📦 EventRepository 생성")
            return EventRepositoryImpl()
        }.inObjectScope(.container)
        
        // UseCase 등록
        container.register(EventUseCaseProtocol.self) { resolver in
            print("📋 EventUseCase 생성")
            let repository = resolver.resolve(EventRepositoryProtocol.self)!
            return EventUseCase(eventRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ HomeAssembly 등록 완료")
    }
}
