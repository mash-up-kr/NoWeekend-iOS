//
//  AppDependencyConfiguration.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation

enum AppDependencyConfiguration {
    static func configure() {
        print("🔧 DI Container 앱 설정 시작")
        
        setupAppConfiguration()
        
        print("✅ DI Container 방식 설정 완료")
    }
    
    private static func setupAppConfiguration() {
        print("🎨 앱 전역 설정 적용")
                
        print("✅ 앱 전역 설정 완료")
    }
}
