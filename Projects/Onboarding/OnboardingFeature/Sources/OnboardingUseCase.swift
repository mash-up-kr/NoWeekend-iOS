import Foundation
import OnboardingDomain

public class OnboardingUseCase: OnboardingUseCaseProtocol {
    private let onboardingRepository: OnboardingRepositoryProtocol
    
    public init(onboardingRepository: OnboardingRepositoryProtocol) {
        self.onboardingRepository = onboardingRepository
        print("🚪 OnboardingUseCase 생성")
    }
    
    public func completeOnboarding(credentials: OnboardingCredentials) async throws -> OnboardingToken {
        print("🚪 온보딩 완료 UseCase 실행")
        return try await onboardingRepository.completeOnboarding(credentials: credentials)
    }
    
    public func skipOnboarding() async throws {
        print("⏭️ 온보딩 건너뛰기 UseCase 실행")
        try await onboardingRepository.skipOnboarding()
    }
}
