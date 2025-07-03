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
        
        // Repository만 등록 (UseCase는 Feature에서 등록)
        container.register(CalendarRepositoryProtocol.self) { _ in
            print("📦 CalendarRepository 생성")
            return CalendarRepositoryImpl()
        }.inObjectScope(.container)
        
        print("✅ CalendarAssembly 등록 완료")
    }
}
