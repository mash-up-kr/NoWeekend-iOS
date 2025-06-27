import SwiftUI
import Domain
import DesignSystem

public struct OnboardingView: View {
    @ObservedObject private var store = OnboardingStore()
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 56) {
                headerView
                
                TabView(selection: Binding(
                    get: { store.state.currentStep },
                    set: { _ in }
                )) {
                    nicknameStepView.tag(0)
                    experienceStepView.tag(1)
                    scheduleStepView.tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: store.state.currentStep)
                
                bottomButtonView
            }
        }
        .background(DS.Colors.Background.white)
        .navigationBarHidden(true)
        .onChange(of: store.state.isOnboardingCompleted) {
            if store.state.isOnboardingCompleted {
                // 온보딩 완료 후 처리 (예: 메인 화면으로 이동)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack {
            HStack {
                Button(action: {
                    store.send(.goToPreviousStep)
                }) {
                    DS.Images.icnChevronLeft
                        .foregroundColor(DS.Colors.Text.gray900)
                }
                .opacity(store.state.currentStep > 0 ? 1 : 0)
                
                Spacer()
                
                Text("\(store.state.currentStep + 1)/\(OnboardingState.totalSteps)")
                    .font(.heading6)
                    .foregroundColor(DS.Colors.Neutral.black)
                
                Spacer()
                
                Button(action: {}) {
                    DS.Images.icnChevronLeft
                }
                .opacity(0)
            }
            .padding(.top, 16)
        }
    }
    
    private var nicknameStepView: some View {
        VStack {
            OnboardingStepView(
                title: "닉네임을 알려주세요!",
                subtitle: "언제든 변경할 수 있어요"
            ) {
                VStack {
                    NWTextField.todoMultiLine(
                        text: Binding(
                            get: { store.state.nickname },
                            set: { store.send(.updateNickname($0)) }
                        ),
                        placeholder: "닉네임 입력하세요.",
                        errorMessage: Binding(
                            get: { store.state.nicknameError },
                            set: { _ in }
                        )
                    )
                }
                .padding(.top, 40)
                .padding(.horizontal, 8)
            }
        }
    }
    
    // MARK: - Experience Step View
    private var experienceStepView: some View {
        OnboardingStepView(
            title: "올해 연차를 입력해주세요",
            subtitle: "숫자로 입력해 주세요."
        ) {
            VStack {
                VStack(alignment: .center) {
                    HStack(alignment: .bottom, spacing: 6) {
                        Text("\(store.state.displayRemainingDays)일 \(store.state.displayRemainingHours)시간")
                            .font(.heading2)
                            .foregroundColor(DS.Colors.Toast._500)
                        
                        Text(" / \(store.state.totalDays)일")
                            .font(.body1)
                            .foregroundColor(DS.Colors.Neutral.black)
                             
                    }
                    .padding(.vertical, 32)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("남은 연차")
                                .font(.subtitle1)
                                .foregroundColor(DS.Colors.Text.gray700)
                            
                            HStack(spacing: 24) {
                                NWTextField.userInputTextField(
                                    text: Binding(
                                        get: { store.state.remainingDays },
                                        set: { store.send(.updateRemainingDays($0)) }
                                    ),
                                    suffixText: "일",
                                    placeholder: "0",
                                    errorMessage: Binding(
                                        get: { store.state.remainingDaysError },
                                        set: { _ in }
                                    )
                                )
                                
                                NWTextField.userInputTextField(
                                text: Binding(
                                        get: { store.state.remainingHours },
                                        set: { store.send(.updateRemainingHours($0)) }
                                ),
                                suffixText: "시간",
                                placeholder: "0",
                                errorMessage: Binding(
                                        get: { store.state.remainingHoursError },
                                        set: { _ in }
                                    )
                                )
                            }
                        }
                        
                        // 전체 연차 섹션
                        VStack(alignment: .leading, spacing: 8) {
                            Text("전체 연차")
                                .font(.subtitle1)
                                .foregroundColor(DS.Colors.Text.gray700)
                            
                            NWTextField.userInputTextField(
                                text: Binding(
                                    get: { store.state.totalDays },
                                    set: { store.send(.updateTotalDays($0)) }
                                ),
                                suffixText: "일",
                                placeholder: "15",
                                errorMessage: Binding(
                                    get: { store.state.totalDaysError },
                                    set: { _ in }
                                )
                            )
                        }
                        .padding(.top, 24)
                        
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }
    
    private var scheduleStepView: some View {
        OnboardingStepView(
            title: "자주하는 일정을 알려주세요",
            subtitle: "일정 등록할 시에게 추천받을 수 있어요"
        ) {
            VStack {
                TagSelectionView(
                    selectedTags: store.state.selectedTags,
                    onTagToggle: { tag in
                        store.send(.toggleTag(tag))
                    }
                )
            }
            .padding(.top, 40)
        }
    }
    
    private var bottomButtonView: some View {
        VStack(spacing: 0) {
            NWButton(
                title: buttonTitle,
                variant: .black,
                isEnabled: store.state.isNextButtonEnabled && !store.state.isLoading
            ) {
                store.send(.goToNextStep)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var buttonTitle: String {
        switch store.state.currentStep {
        case 0, 1:
            return "다음"
        case 2:
            if store.state.isNextButtonEnabled {
                return "시작하기"
            } else {
                return "3개 이상 선택해주세요"
            }
        default:
            return "다음"
        }
    }
}

#Preview {
    OnboardingView()
}
