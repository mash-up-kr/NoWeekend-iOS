import SwiftUI
import Home
import Profile
import Calendar
import Onboarding
import UseCase
import Repository
import Entity
import Network
import Storage

@main
struct NoWeekendApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// MARK: - Main TabView (Simple DI)
struct MainTabView: View {
    // Simple dependency injection
    private let eventUseCase: EventUseCase
    private let userUseCase: UserUseCase
    
    init() {
        // Create network service
        let networkService = NetworkService(
            baseURL: "", // TODO: 실제 API URL로 변경 + Config
            headers: ["Content-Type": "application/json"]
        )
        
        // Create storage
        let storage = UserDefaultsStorage()
        
        // Create repositories
        let eventRepository = EventRepository(
            networkService: networkService,
            storage: storage
        )
        let userRepository = UserRepository(
            networkService: networkService,
            storage: storage
        )
        
        // Create use cases
        self.eventUseCase = EventUseCase(eventRepository: eventRepository)
        self.userUseCase = UserUseCase(userRepository: userRepository)
    }
    
    var body: some View {
        TabView {
            HomeView(eventUseCase: eventUseCase)
                .tabItem {
                    Label("홈", systemImage: "house")
                }
            
            CalendarView(eventUseCase: eventUseCase)
                .tabItem {
                    Label("캘린더", systemImage: "calendar")
                }
            
            ProfileView(userUseCase: userUseCase)
                .tabItem {
                    Label("프로필", systemImage: "person")
                }
        }
    }
}
