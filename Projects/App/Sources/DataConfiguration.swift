//
//  DataConfiguration.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import DataBridge

enum DataConfiguration {
    static func configure() {
        print("📦 Data 모듈들 활성화 시작")
        
        // DataBridge를 통해 모든 Data 모듈 활성화
        DataBridge.configure()
        
        print("✅ 모든 Data 모듈 활성화 완료")
    }
}
