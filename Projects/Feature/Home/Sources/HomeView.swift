import SwiftUI
import HomeInterface
import Domain
import DesignSystem
import Common

public struct HomeView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Text("나희")
                .font(Typography.title)
        }
    }
}

#Preview {
    HomeView()
}
