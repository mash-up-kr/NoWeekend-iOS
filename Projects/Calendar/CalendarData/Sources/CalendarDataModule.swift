//
//  CalendarDataModule.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import DIContainer
import CalendarDomain

public enum CalendarDataModule {
    public static func registerRepositories() {
        print("📅 CalendarData Repository 등록")
        
        // Domain Protocol을 Data 모듈에서 등록
        DIContainer.shared.container.register(CalendarRepositoryProtocol.self) { _ in
            return CalendarRepositoryImpl()
        }.inObjectScope(.container)
        
        print("✅ CalendarData Repository 등록 완료")
    }
}
