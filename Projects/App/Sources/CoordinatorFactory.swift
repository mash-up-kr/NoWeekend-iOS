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
        HomeCoordinatorView()
    }
    
    var profileCoordinatorRootView: some View {
        ProfileCoordinatorView()
    }
    
    var calendarCoordinatorRootView: some View {
        CalendarCoordinatorView()
    }
}
