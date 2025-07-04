//
//  CalendarFeatureModule.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core
import Swinject
import CalendarDomain

public enum CalendarFeatureModule {
    public static func registerUseCases() {
        print("📅 CalendarFeature UseCase 등록")
        
        let assembly = CalendarFeatureAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ CalendarFeature UseCase 등록 완료")
    }
}
