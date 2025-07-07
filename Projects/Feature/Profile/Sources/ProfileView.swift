import DesignSystem
import Domain
import ProfileInterface
import SwiftUI

public struct ProfileView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            LottieView(type: JSONFiles.Loading.self, loopMode: .playOnce)
                .frame(width: 100, height: 100)

            Text("시종")
                .font(.heading2)
                .foregroundColor(DS.Colors.Text.netural)
        }
    }
}

#Preview {
    ProfileView()
}
