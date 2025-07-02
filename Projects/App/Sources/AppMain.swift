import SwiftUI
import Login
import Onboarding

@main
struct AppMain: App {
    var body: some Scene {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
        WindowGroup {
            let onboardingStore = DIContainer.shared.makeOnboardingStore()
            OnboardingView(store: onboardingStore)
        }
    }
}
