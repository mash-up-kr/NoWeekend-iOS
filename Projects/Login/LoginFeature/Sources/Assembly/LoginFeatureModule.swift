//
//  LoginFeatureModule.swift
//  LoginFeature
//
//  Created by SiJongKim on 7/7/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import DIContainer
import Swinject
import LoginDomain

public enum LoginFeatureModule {
    public static func registerUseCases() {
        print("🔐 LoginFeature UseCase 등록 시작")
        
        let assembly = LoginFeatureAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ LoginFeature UseCase 등록 완료")
    }
}
