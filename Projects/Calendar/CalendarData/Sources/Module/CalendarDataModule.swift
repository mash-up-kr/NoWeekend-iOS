//
//  CalendarDataModule.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//

import CalendarDomain
import DIContainer
import Foundation
import NWNetwork

public enum CalendarDataModule {
    public static func registerRepositories() {
        print("📅 CalendarData Repository 등록")
        
        DIContainer.shared.container.register(CalendarRepositoryProtocol.self) { _ in
            CalendarRepositoryImpl()
            
        DIContainer.shared.container.register(CalendarRepositoryProtocol.self) { resolver in
            let networkService = resolver.resolve(NWNetworkServiceProtocol.self)!
            return CalendarRepositoryImpl(networkService: networkService)
        }.inObjectScope(.container)
        
        print("✅ CalendarData Repository 등록 완료")
    }
}
