import SwiftUI
import OnboardingInterface
import DesignSystem

// MARK: - Onboarding View Implementation
public struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    
    public init() {
        self._viewModel = StateObject(wrappedValue: OnboardingViewModel())
    }
    
    public var body: some View {
        VStack(spacing: 40) {
            // Progress Indicator
            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index <= viewModel.currentStep ? DS.Colors.TaskItem.orange : DS.Colors.Border.gray200)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Onboarding Content
            VStack(spacing: 24) {
//                DS.Images.imgMain
//                    .frame(width: 200, height: 200)
//                
                VStack(spacing: 16) {
                    Text(viewModel.currentTitle)
//                        .font(Font.heading1)
                        .foregroundColor(DS.Colors.Text.gray900)
                        .multilineTextAlignment(.center)
                    
                    Text(viewModel.currentDescription)
                        .font(Font.body1)
                        .foregroundColor(DS.Colors.Text.gray700)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                Button(action: {
                    viewModel.nextStep()
                }) {
                    Text(viewModel.primaryButtonTitle)
//                        .font(Font.button)
                        .foregroundColor(DS.Colors.Background.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(DS.Colors.TaskItem.orange)
                        .cornerRadius(12)
                }
                
                if viewModel.showSkipButton {
                    Button(action: {
                        viewModel.skipOnboarding()
                    }) {
                        Text("건너뛰기")
                            .font(Font.body2)
                            .foregroundColor(DS.Colors.Text.gray700)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
    }
}

// MARK: - ViewModel Implementation
@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isOnboardingCompleted: Bool = false
    @Published var currentStep: Int = 0
    
    private let onboardingSteps = [
        OnboardingStep(
            title: "No Weekend에\n오신 것을 환영합니다!",
            description: "주말 없는 일상을 효율적으로\n관리해보세요",
            imageName: "img_home"
        ),
        OnboardingStep(
            title: "일정 관리를\n스마트하게",
            description: "캘린더로 일정을 한눈에 보고\n체계적으로 관리하세요",
            imageName: "img_calendar"
        ),
        OnboardingStep(
            title: "나만의 프로필로\n개인화하기",
            description: "테마와 설정을 조정하여\n나에게 맞는 환경을 만드세요",
            imageName: "img_profile"
        )
    ]
    
    var currentTitle: String {
        guard currentStep < onboardingSteps.count else { return "" }
        return onboardingSteps[currentStep].title
    }
    
    var currentDescription: String {
        guard currentStep < onboardingSteps.count else { return "" }
        return onboardingSteps[currentStep].description
    }
    
    var primaryButtonTitle: String {
        if currentStep < onboardingSteps.count - 1 {
            return "다음"
        } else {
            return "시작하기"
        }
    }
    
    var showSkipButton: Bool {
        return currentStep < onboardingSteps.count - 1
    }
    
    func nextStep() {
        if currentStep < onboardingSteps.count - 1 {
            withAnimation(.easeInOut) {
                currentStep += 1
            }
        } else {
            completeOnboarding()
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            withAnimation(.easeInOut) {
                currentStep -= 1
            }
        }
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
        // TODO: UserDefaults나 Storage를 통해 온보딩 완료 상태 저장
        print("Onboarding completed!")
    }
    
    func skipOnboarding() {
        completeOnboarding()
    }
}

// MARK: - Onboarding Step Model
private struct OnboardingStep {
    let title: String
    let description: String
    let imageName: String
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
