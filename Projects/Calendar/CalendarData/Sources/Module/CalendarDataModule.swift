//
//  CalendarDataModule.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import DIContainer
import CalendarDomain
import NWNetwork

public enum CalendarDataModule {
    public static func registerRepositories() {
        print("📅 CalendarData Repository 등록")
        
        DIContainer.shared.container.register(CalendarRepositoryProtocol.self) { resolver in
            let networkService = resolver.resolve(NWNetworkServiceProtocol.self)!
            return CalendarRepositoryImpl(networkService: networkService)
        }.inObjectScope(.container)
        
        print("✅ CalendarData Repository 등록 완료")
    }
}
