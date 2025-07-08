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
    @State private var appState = AppState()
    
    init() {}
    
    var body: some View {
        Group {
            if appState.isLoading {
                LoadingView()
            } else if !appState.isLoggedIn {
                LoginView()
            } else if !appState.isOnboardingCompleted {
                OnboardingView {
                    appState.completeOnboarding()
                }
            } else {
                TabBarView()
            }
        }
        .onAppear {
            appState.checkLoginStatus()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

#Preview {
    ContentView()
}
