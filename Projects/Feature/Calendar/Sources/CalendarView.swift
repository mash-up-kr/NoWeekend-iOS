import SwiftUI
import CalendarInterface
import Domain
import DesignSystem

public struct CalendarView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            LottieView(type: JSONFiles.Fire.self)
                .frame(width: 100, height: 100)            
            Text("지훈")
        }
    }
}

#Preview {
    CalendarView()
}
