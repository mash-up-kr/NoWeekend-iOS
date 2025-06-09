import SwiftUI
import DesignSystem
import Domain
import Util
import Common

public struct CalendarView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack {
                Text("Calendar")
                    .font(.largeTitle)
                
                Text("Current time: \(Date().toString())")  // Util 사용
                
                Spacer()
            }
            .padding(UIConstants.padding)  // Common 사용
            .navigationTitle("Calendar")
        }
    }
}

#Preview {
    CalendarView()
}
