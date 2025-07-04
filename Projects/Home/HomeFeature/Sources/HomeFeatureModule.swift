//
//  HomeFeatureModule.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core
import Swinject
import HomeDomain

public enum HomeFeatureModule {
    public static func registerUseCases() {
        print("🏠 HomeFeature UseCase 등록")
        
        let assembly = HomeFeatureAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ HomeFeature UseCase 등록 완료")
    }
}
