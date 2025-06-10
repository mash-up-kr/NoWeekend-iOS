import SwiftUI
import Home
import Profile
import Calendar
import DesignSystem
import Common

public struct TabBarView: View {
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(Colors.primary)
    }
}

#Preview {
    TabBarView()
}
