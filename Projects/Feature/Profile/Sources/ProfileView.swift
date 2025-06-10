import SwiftUI
import ProfileInterface
import Domain
import DesignSystem
import Common

public struct ProfileView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("시종")
                .font(Typography.title)
        }
    }
}

#Preview {
    ProfileView()
}
