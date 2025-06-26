import Foundation
import SwiftUI
import HomeInterface
import ProfileInterface
import CalendarInterface
import OnboardingInterface

// MARK: - Mock Home Builder
public final class MockHomeBuilder: HomeBuilder {
    public init() {}
    
    public func makeHomeView() -> AnyView {
        return AnyView(
            VStack {
                Text("🏠 Mock Home")
                    .font(.title)
                    .foregroundColor(.blue)
                Text("테스트용 홈 화면")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        )
    }
}

// MARK: - Mock Profile Builder
public final class MockProfileBuilder: ProfileBuilder {
    public init() {}
    
    public func makeProfileView() -> AnyView {
        return AnyView(
            VStack {
                Text("👤 Mock Profile")
                    .font(.title)
                    .foregroundColor(.green)
                Text("테스트용 프로필 화면")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        )
    }
}

// MARK: - Mock Calendar Builder
public final class MockCalendarBuilder: CalendarBuilder {
    public init() {}
    
    public func makeCalendarView() -> AnyView {
        return AnyView(
            VStack {
                Text("📅 Mock Calendar")
                    .font(.title)
                    .foregroundColor(.orange)
                Text("테스트용 캘린더 화면")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        )
    }
}

// MARK: - Mock Onboarding Builder
public final class MockOnboardingBuilder: OnboardingBuilder {
    public init() {}
    
    public func makeOnboardingView() -> AnyView {
        return AnyView(
            VStack {
                Text("✨ Mock Onboarding")
                    .font(.title)
                    .foregroundColor(.purple)
                Text("테스트용 온보딩 화면")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        )
    }
}

// MARK: - Mock TabBar Component
public final class MockTabBarComponent {
    public let homeBuilder: HomeBuilder = MockHomeBuilder()
    public let profileBuilder: ProfileBuilder = MockProfileBuilder()
    public let calendarBuilder: CalendarBuilder = MockCalendarBuilder()
    public let onboardingBuilder: OnboardingBuilder = MockOnboardingBuilder()
    
    public init() {}
} 