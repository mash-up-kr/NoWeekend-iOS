import SwiftUI
import Home
import Profile
import Calendar
import DesignSystem

public struct TabBarView: View {
    public enum Tab: Int, CaseIterable {
        case home = 0
        case calendar
        case profile

        var title: String {
            switch self {
            case .home: return "홈"
            case .calendar: return "캘린더"
            case .profile: return "내 정보"
            }
        }

        var iconOn: Image {
            switch self {
            case .home: return DS.Images.icnHomeOn
            case .calendar: return DS.Images.icnCalendarOn
            case .profile: return DS.Images.icnPersonOn
            }
        }

        var iconOff: Image {
            switch self {
            case .home: return DS.Images.icnHomeOff
            case .calendar: return DS.Images.icnCalendarOff
            case .profile: return DS.Images.icnPersonOff
            }
        }
    }

    @State private var selectedTab: Tab = .home

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    (selectedTab == .home ? Tab.home.iconOn : Tab.home.iconOff)
                    Text(Tab.home.title)
                }
                .tag(Tab.home)

            CalendarView()
                .tabItem {
                    (selectedTab == .calendar ? Tab.calendar.iconOn : Tab.calendar.iconOff)
                    Text(Tab.calendar.title)
                }
                .tag(Tab.calendar)

            ProfileView()
                .tabItem {
                    (selectedTab == .profile ? Tab.profile.iconOn : Tab.profile.iconOff)
                    Text(Tab.profile.title)
                }
                .tag(Tab.profile)
        }
        .accentColor(DS.Colors.Neutral._900)
    }
}

#Preview {
    TabBarView()
}
