//
//  CalendarDataModule.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//

import CalendarDomain
import DIContainer
import Foundation

public enum CalendarDataModule {
    public static func registerRepositories() {
        print("📅 CalendarData Repository 등록")
        
        DIContainer.shared.container.register(CalendarRepositoryProtocol.self) { _ in
            CalendarRepositoryImpl()
        }.inObjectScope(.container)
        
        print("✅ CalendarData Repository 등록 완료")
    }
}
