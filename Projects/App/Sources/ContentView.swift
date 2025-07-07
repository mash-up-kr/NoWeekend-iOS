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

@MainActor
struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var appState = AppState()
    
    private let coordinatorFactory: CoordinatorFactory = CoordinatorFactory()
    
    init() {
        print("📱 ContentView 초기화 (온보딩 로직 포함)")
    }
    
    var body: some View {
        Group {
            if appState.isLoading {
                VStack {
                    ProgressView()
                    Text("로딩 중...")
                        .padding(.top)
                }
            } else if !appState.isOnboardingCompleted {
                OnboardingView {
                    appState.completeOnboarding()
                }
            } else {
                TabView(selection: $selectedTab) {
                    // 홈 탭
                    coordinatorFactory.homeCoordinatorRootView
                        .tabItem {
                            (selectedTab == .home ? Tab.home.iconOn : Tab.home.iconOff)
                            Text(Tab.home.title)
                        }
                        .tag(Tab.home)
                    
                    // 캘린더 탭
                    coordinatorFactory.calendarCoordinatorRootView
                        .tabItem {
                            (selectedTab == .calendar ? Tab.calendar.iconOn : Tab.calendar.iconOff)
                            Text(Tab.calendar.title)
                        }
                        .tag(Tab.calendar)
                    
                    // 프로필 탭
                    coordinatorFactory.profileCoordinatorRootView
                        .tabItem {
                            (selectedTab == .profile ? Tab.profile.iconOn : Tab.profile.iconOff)
                            Text(Tab.profile.title)
                        }
                        .tag(Tab.profile)
                    
                }
                .accentColor(.black)
            }
        }
        .onAppear {
            appState.checkOnboardingStatus()
        }
    }
}

// MARK: - Tab Enum
extension ContentView {
    enum Tab: Int, CaseIterable {
        case home = 0
        case calendar
        case profile
        
        var title: String {
            switch self {
            case .home: return "홈"
            case .calendar: return "캘린더"
            case .profile: return "내 정보"
            }
        }
        
        var iconOn: Image {
            switch self {
            case .home: return Image(systemName: "house.fill")
            case .calendar: return Image(systemName: "calendar.circle.fill")
            case .profile: return Image(systemName: "person.fill")
            }
        }
        
        var iconOff: Image {
            switch self {
            case .home: return Image(systemName: "house")
            case .calendar: return Image(systemName: "calendar.circle")
            case .profile: return Image(systemName: "person")
            }
        }
    }
}

#Preview {
    ContentView()
}
