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
                Text("Welcome to \(AppConstants.appName)!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // DesignSystem 컴포넌트 사용
                PrimaryButton(title: "Get Started") {
                    // 액션
                }
                
                Spacer()
            }
            .padding(UIConstants.padding)
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
