import SwiftUI
import Login
import Onboarding
import TabBar

struct ContentView: View {
    @StateObject private var loginStore = DIContainer.shared.makeLoginStore()
    @State private var showingOnboarding = false
    @State private var showingTabBar = false
    
    // 온보딩 스토어를 lazy로 생성 (필요할 때만 생성)
    @State private var onboardingStore: OnboardingStore?
    
    var body: some View {
        content
            .onReceive(loginStore.effect) { effect in
                switch effect {
                case .showError:
                    break
                case .navigateToHome:
                    showingOnboarding = true
                @unknown default:
                    break
                }
            }
    }
    
    @ViewBuilder
    private var content: some View {
        if showingTabBar {
            TabBarView()
        } else if showingOnboarding {
            onboardingView
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
    
    @ViewBuilder
    private var onboardingView: some View {
        let store = getCurrentOnboardingStore()
        OnboardingView(store: store)
            .onChange(of: store.state.isOnboardingCompleted) { _, isCompleted in
                if isCompleted {
                    showingTabBar = true
                    showingOnboarding = false
                    onboardingStore = nil // 메모리 정리
                }
            }
    }
    
    private func getCurrentOnboardingStore() -> OnboardingStore {
        if onboardingStore == nil {
            onboardingStore = DIContainer.shared.makeOnboardingStore()
        }
        return onboardingStore!
    }
}
