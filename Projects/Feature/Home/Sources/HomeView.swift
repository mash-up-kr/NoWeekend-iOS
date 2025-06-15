import SwiftUI
import HomeInterface
import Domain
import DesignSystem

public struct HomeView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            DS.Images.imgCake
            Text("나희")
                .font(Font.heading2)
                .foregroundColor(DS.Colors.Text.gray900)
        }
    }
}

#Preview {
    HomeView()
}
