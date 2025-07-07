//
//  ContentView.swift
//  NoWeekend
//
//  Created by 이지훈 on 7/3/25.
//

import SwiftUI
import HomeFeature
import ProfileFeature
import CalendarFeature
import OnboardingFeature
import LoginFeature
import DesignSystem

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
