import Foundation
import SwiftUI

// MARK: - Onboarding Builder Protocol
public protocol OnboardingBuilder {
    func makeOnboardingView() -> AnyView
} 
