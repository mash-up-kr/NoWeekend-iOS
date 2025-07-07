//
//  UtilsModule.swift
//  DesignSystem
//
//  Created by 김시종 on 7/7/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import DIContainer

public enum UtilsModule {
    public static func registerUtilities() {
        print("🔧 공통 유틸리티 등록 시작")
        
        let utilsAssembly = UtillsAssembly()
        DIContainer.shared.registerAssembly(assembly: [utilsAssembly])
        
        print("✅ 공통 유틸리티 등록 완료")
    }
}
