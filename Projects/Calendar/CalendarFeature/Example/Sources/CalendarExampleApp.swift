//
//  MockCalendarRepository.swift
//  CalendarExampleApp
//
//  Created by 이지훈 on 7/22/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import CalendarFeature
import CalendarDomain
import DIContainer
import Swinject

@main
struct CalendarExampleApp: App {
    
    init() {
        setupMockDI()
    }
    
    var body: some Scene {
        WindowGroup {
            CalendarCoordinatorView()
                .environmentObject(CalendarCoordinator())
        }
    }
    
    private func setupMockDI() {
        // Mock Repository만 등록
        DIContainer.shared.container.register(CalendarRepositoryProtocol.self) { _ in
            MockCalendarRepository()
        }
        
        // UseCase 등록
        DIContainer.shared.container.register(CalendarUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(CalendarRepositoryProtocol.self)!
            return CalendarUseCase(calendarRepository: repository)
        }
    }
}
