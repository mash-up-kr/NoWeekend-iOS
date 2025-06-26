import Foundation
import SwiftUI
import NeedleFoundation
import HomeInterface
import ProfileInterface
import CalendarInterface
import OnboardingInterface

// MARK: - TabBar Component Dependency
protocol TabBarDependency: Dependency {
    var homeBuilder: HomeBuilder { get }
    var profileBuilder: ProfileBuilder { get }
    var calendarBuilder: CalendarBuilder { get }
    var onboardingBuilder: OnboardingBuilder { get }
}

// MARK: - TabBar Component
final class TabBarComponent: Component<TabBarDependency> {
    
    var homeBuilder: HomeBuilder {
        return dependency.homeBuilder
    }
    
    var profileBuilder: ProfileBuilder {
        return dependency.profileBuilder
    }
    
    var calendarBuilder: CalendarBuilder {
        return dependency.calendarBuilder
    }
    
    var onboardingBuilder: OnboardingBuilder {
        return dependency.onboardingBuilder
    }
}

// MARK: - Root Component Protocol
protocol RootComponentDependency: Dependency {
    // 외부에서 주입받을 의존성들 (보통 비어있음)
}

// MARK: - Root Component
final class RootComponent: Component<RootComponentDependency> {
    
    // MARK: - TabBar Component
    var tabBarComponent: TabBarComponent {
        return TabBarComponent(parent: self)
    }
    
    // MARK: - Feature Builders (Individual Access)
    var homeBuilder: HomeBuilder {
        return HomeComponent(parent: self)
    }
    
    var profileBuilder: ProfileBuilder {
        return ProfileComponent(parent: self)
    }
    
    var calendarBuilder: CalendarBuilder {
        return CalendarComponent(parent: self)
    }
    
    var onboardingBuilder: OnboardingBuilder {
        return OnboardingComponent(parent: self)
    }
}

// MARK: - RootComponent Extensions
extension RootComponent: TabBarDependency {
    // homeBuilder, profileBuilder 등은 이미 위에서 정의됨
}

extension RootComponent: HomeDependency {
    var eventUseCase: EventUseCase {
        return shared { EventUseCase(eventRepository: eventRepository) }
    }
    
    var userUseCase: UserUseCase {
        return shared { UserUseCase(userRepository: userRepository) }
    }
    
    // MARK: - Repository Dependencies
    private var eventRepository: EventRepository {
        return shared { EventRepository() }
    }
    
    private var userRepository: UserRepository {
        return shared { UserRepository() }
    }
}

extension RootComponent: ProfileDependency {
    // userUseCase는 이미 HomeDependency에서 정의됨
}

extension RootComponent: CalendarDependency {
    // eventUseCase는 이미 HomeDependency에서 정의됨
}

extension RootComponent: OnboardingDependency {
    // 온보딩은 별도의 의존성이 없음
}

// MARK: - Application Entry Point
public final class DIContainer {
    public static let shared = DIContainer()
    
    private let rootComponent = RootComponent()
    
    private init() {
        registerProviderFactory()
    }
    
    // MARK: - Builders 제공 (Builder 패턴)ㄴ
    public var homeBuilder: HomeBuilder {
        return rootComponent.homeBuilder
    }
    
    public var profileBuilder: ProfileBuilder {
        return rootComponent.profileBuilder
    }
    
    public var calendarBuilder: CalendarBuilder {
        return rootComponent.calendarBuilder
    }
    
    public var onboardingBuilder: OnboardingBuilder {
        return rootComponent.onboardingBuilder
    }
    
    public var tabBarComponent: TabBarComponent {
        return rootComponent.tabBarComponent
    }
}

// MARK: - Empty Dependency for Root
fileprivate class EmptyComponent: Component<EmptyDependency> {
    init() {
        super.init(parent: EmptyDependency())
    }
}

fileprivate class EmptyDependency: Dependency {
    init() {}
} 