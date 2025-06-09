import SwiftUI
import Home
import Calendar
import Profile

public struct TabBarView: View {
    public init() {}
    
    public var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    TabBarView()
}
