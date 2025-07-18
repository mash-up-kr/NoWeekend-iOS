//
//  ContentView.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import CalendarFeature
import DesignSystem
import HomeFeature
import LoginFeature
import OnboardingFeature
import ProfileFeature
import SwiftUI

@MainActor
struct ContentView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    
    init() {}
    
    var body: some View {
        AppCoordinatorView()
            .environmentObject(appCoordinator)
    }
}

#Preview {
    ContentView()
}
