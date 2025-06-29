import SwiftUI
import Login
import Onboarding
import TabBar

struct ContentView: View {
    @StateObject private var loginStore = DIContainer.shared.makeLoginStore()
    @State private var showingOnboarding = false
    @State private var showingTabBar = false
    
    var body: some View {
        content
            .onReceive(loginStore.effect) { effect in
                switch effect {
                case .showError:
                    break
                case .navigateToHome:
                    showingOnboarding = true
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if showingTabBar {
            TabBarView()
        } else if showingOnboarding {
            OnboardingView()
//                .onReceive(NotificationCenter.default.publisher(for: .onboardingCompleted)) { _ in
//                    showingTabBar = true
//                    showingOnboarding = false
//                }
        } else {
            LoginView(store: loginStore)
                .alert("에러", isPresented: .constant(!loginStore.state.errorMessage.isEmpty)) {
                    Button("확인") {
                    }
                } message: {
                    Text(loginStore.state.errorMessage)
                }
                .overlay(
                    Group {
                        if loginStore.state.isLoading {
                            ProgressView()
                        }
                    }
                )
        }
    }
}
