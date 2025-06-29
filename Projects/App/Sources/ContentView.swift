import SwiftUI
import Login
import Onboarding

@MainActor
struct ContentView: View {
    var body: some View {
        LoginView(store: DIContainer.shared.loginStore)
    }
}

#Preview {
    ContentView()
}
