import SwiftUI
import DesignSystem
import Domain
import Util  
import Common

public struct HomeView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome to \(AppConstants.appName)!")  // Common 사용
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your weekend planning app")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // DesignSystem 컴포넌트 사용
                PrimaryButton(title: "Get Started") {
                    // 액션
                }
                
                Spacer()
            }
            .padding(UIConstants.padding)  // Common 사용
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
