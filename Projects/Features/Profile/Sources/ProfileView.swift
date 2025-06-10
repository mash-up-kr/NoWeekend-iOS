import SwiftUI
import DesignSystem
import Domain
import Util
import Common

///더미입니다
public struct ProfileView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(UIConstants.padding)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
