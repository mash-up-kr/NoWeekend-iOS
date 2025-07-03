//
//  OnboardingDataModule.swift
//  OnboardingData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import Core

public enum OnboardingDataModule {
    @AutoRegisterData
    static var assembly = OnboardingAssembly()
    
    public static func configure() {
        print("🚪 OnboardingDataModule 활성화")
        _ = assembly // PropertyWrapper 활성화
    }
}
