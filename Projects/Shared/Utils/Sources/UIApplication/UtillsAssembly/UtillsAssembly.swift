//
//  CommonAssembly.swift
//  DesignSystem
//
//  Created by 김시종 on 7/7/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Swinject

public struct UtillsAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        print("🔧 CommonAssembly 등록 시작")
        
        container.register(ViewControllerProviderInterface.self) { _ in
            return MainActor.assumeIsolated {
                ViewControllerProvider()
            }
        }.inObjectScope(.container)
        
        print("✅ CommonAssembly 등록 완료")
    }
}
