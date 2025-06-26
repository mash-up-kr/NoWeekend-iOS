import NeedleFoundation
import Onboarding

// MARK: - Onboarding Component Dependency
protocol OnboardingComponentDependency: Dependency {
    // 온보딩은 별도의 UseCase 의존성이 없음
}

// MARK: - Onboarding Component (Builder 구현)
final class OnboardingComponent: Component<OnboardingDependency>, OnboardingBuilder {
    
    func makeOnboardingView() -> AnyView {
        return AnyView(OnboardingView())
    }
}

 