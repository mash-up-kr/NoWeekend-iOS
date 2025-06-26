import Foundation
import SwiftUI
import NeedleFoundation

// MARK: - Onboarding Dependency Protocol  
public protocol OnboardingDependency: Dependency {
}

// MARK: - Onboarding Builder Protocol
public protocol OnboardingBuilder {
    func makeOnboardingView() -> AnyView
} 