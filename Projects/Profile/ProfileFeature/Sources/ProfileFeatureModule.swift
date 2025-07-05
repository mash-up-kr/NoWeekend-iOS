//
//  ProfileFeatureModule.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import DIContainer
import Swinject
import ProfileDomain

// MARK: - Module Registration
public enum ProfileFeatureModule {
    public static func registerUseCases() {
        print("👤 ProfileFeature UseCase 등록")
        
        let assembly = ProfileFeatureAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ ProfileFeature UseCase 등록 완료")
    }
}
