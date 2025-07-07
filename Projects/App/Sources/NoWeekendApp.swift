//
//  NoWeekendApp.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import SwiftUI

@main
struct NoWeekendApp: App {
    
    init() {
        print("🚀 NoWeekend 앱 시작 (DI Container 방식)")
        
        AppDependencyConfiguration.configure()
        
        print("✅ 앱 초기화 완료 - DI Container 설정 완료")
    }
    
    var body: some Scene {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
        WindowGroup {
            ContentView()
        }
    }
}
