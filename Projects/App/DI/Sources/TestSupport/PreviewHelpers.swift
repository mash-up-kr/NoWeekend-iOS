import SwiftUI
import HomeInterface
import ProfileInterface
import CalendarInterface
import OnboardingInterface

// MARK: - Preview Wrapper
public struct PreviewWrapper: View {
    let mockComponent = MockTabBarComponent()
    
    public init() {}
    
    public var body: some View {
        TabView {
            mockComponent.homeBuilder.makeHomeView()
                .tabItem { Label("홈", systemImage: "house") }
            
            mockComponent.calendarBuilder.makeCalendarView()
                .tabItem { Label("캘린더", systemImage: "calendar") }
            
            mockComponent.profileBuilder.makeProfileView()
                .tabItem { Label("프로필", systemImage: "person") }
        }
    }
}

// MARK: - Individual Preview Helpers
public struct HomePreviewWrapper: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            MockHomeBuilder().makeHomeView()
        }
    }
}

public struct ProfilePreviewWrapper: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            MockProfileBuilder().makeProfileView()
        }
    }
}

public struct CalendarPreviewWrapper: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            MockCalendarBuilder().makeCalendarView()
        }
    }
}

// MARK: - Navigation Support
public final class NavigationBuilder {
    private let homeBuilder: HomeBuilder
    private let profileBuilder: ProfileBuilder
    private let calendarBuilder: CalendarBuilder
    
    public init(
        homeBuilder: HomeBuilder,
        profileBuilder: ProfileBuilder,
        calendarBuilder: CalendarBuilder
    ) {
        self.homeBuilder = homeBuilder
        self.profileBuilder = profileBuilder
        self.calendarBuilder = calendarBuilder
    }
    
    // 내비게이션으로 뷰 푸시
    public func pushHomeView() -> AnyView {
        return homeBuilder.makeHomeView()
    }
    
    public func pushProfileView() -> AnyView {
        return profileBuilder.makeProfileView()
    }
    
    public func pushCalendarView() -> AnyView {
        return calendarBuilder.makeCalendarView()
    }
}

// MARK: - SwiftUI Preview Extensions
#if DEBUG
public struct MainTabView_Previews: PreviewProvider {
    public static var previews: some View {
        PreviewWrapper()
    }
}

public struct HomeView_Previews: PreviewProvider {
    public static var previews: some View {
        HomePreviewWrapper()
    }
}

public struct ProfileView_Previews: PreviewProvider {
    public static var previews: some View {
        ProfilePreviewWrapper()
    }
}

public struct CalendarView_Previews: PreviewProvider {
    public static var previews: some View {
        CalendarPreviewWrapper()
    }
}
#endif 