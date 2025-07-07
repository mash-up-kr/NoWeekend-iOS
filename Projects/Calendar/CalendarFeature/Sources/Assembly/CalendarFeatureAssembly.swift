//
//  CalendarFeatureAssembly.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import DIContainer
import Foundation
import Swinject

public struct CalendarFeatureAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("📅 CalendarFeatureAssembly 등록 시작")
        
        // UseCase만 등록
        container.register(CalendarUseCaseProtocol.self) { resolver in
            print("📋 CalendarUseCase 생성 (Feature)")
            let repository = resolver.resolve(CalendarRepositoryProtocol.self)!
            return CalendarUseCase(calendarRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ CalendarFeatureAssembly 등록 완료")
    }
}
