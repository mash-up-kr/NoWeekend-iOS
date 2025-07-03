//
//  CalendarAssembly.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Swinject
import CalendarDomain
import Core

public struct CalendarAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("📅 CalendarAssembly 등록 시작")
        
        // Repository 등록
        container.register(CalendarRepositoryProtocol.self) { _ in
            print("📦 CalendarRepository 생성")
            return CalendarRepositoryImpl()
        }.inObjectScope(.container)
        
        // UseCase 등록
        container.register(CalendarUseCaseProtocol.self) { resolver in
            print("📋 CalendarUseCase 생성")
            let repository = resolver.resolve(CalendarRepositoryProtocol.self)!
            return CalendarUseCase(calendarRepository: repository)
        }.inObjectScope(.graph)
        
        print("✅ CalendarAssembly 등록 완료")
    }
}
