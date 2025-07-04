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

// DataBridge는 모든 Data 모듈들을 한곳에 모아주는 역할
public enum DataBridge {
    public static func initialize() {
        print("🌉 DataBridge 초기화 시작")
        
        // 모든 Data 모듈의 Repository 등록
        HomeDataModule.registerRepositories()
        ProfileDataModule.registerRepositories()
        CalendarDataModule.registerRepositories()
        OnboardingDataModule.registerRepositories()
        
        print("✅ DataBridge 초기화 완료")
    }
}
