//
//  CoordinatorFactory.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import SwiftUI
import HomeFeature
import ProfileFeature
import CalendarFeature

@MainActor
struct CoordinatorFactory {
    
    init() {}
    
    var homeCoordinatorRootView: some View {
        let coordinator = HomeCoordinator()
        return HomeCoordinatorView()
            .environment(coordinator)
    }
    
    var profileCoordinatorRootView: some View {
        let coordinator = ProfileCoordinator()
        return ProfileCoordinatorView()
            .environment(coordinator)
    }
    
    var calendarCoordinatorRootView: some View {
        CalendarView()
    }
}
