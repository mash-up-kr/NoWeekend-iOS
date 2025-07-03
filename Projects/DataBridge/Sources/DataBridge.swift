//
//  DataBridge.swift
//  DataBridge
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import HomeData
import ProfileData
import CalendarData
import OnboardingData

public enum DataBridge {
    public static func configure() {
        print("🌉 DataBridge 활성화")
        
        HomeDataModule.configure()
        ProfileDataModule.configure()
        CalendarDataModule.configure()
        OnboardingDataModule.configure()
        
        print("✅ DataBridge 완료")
    }
}
