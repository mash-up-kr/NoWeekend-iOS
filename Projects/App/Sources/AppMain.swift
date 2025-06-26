import DI

@main
struct NoWeekendApp: App {
    
    init() {
        // Needle DI 그래프 초기화
        registerProviderFactory()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(component: DIContainer.shared.tabBarComponent)
        }
    }
}

// MARK: - Main TabView
struct MainTabView: View {
    let component: TabBarComponent
    
    var body: some View {
        TabView {
            component.homeBuilder.makeHomeView()
                .tabItem {
                    Label("홈", systemImage: "house")
                }
            
            component.calendarBuilder.makeCalendarView()
                .tabItem {
                    Label("캘린더", systemImage: "calendar")
                }
            
            component.profileBuilder.makeProfileView()
                .tabItem {
                    Label("프로필", systemImage: "person")
                }
        }
    }
}
