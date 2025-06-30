import SwiftUI
import Domain
import DesignSystem

public struct OnboardingView: View {
    @ObservedObject private var store = OnboardingStore()
    @State private var isGoingBack = false // 뒤로가기 상태 추적
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.bottom, 56)
                .padding(.horizontal, 24)
            
            Group {
                switch store.state.currentStep {
                case 0:
                    nicknameStepView
                        .transition(.asymmetric(
                            insertion: .move(edge: isGoingBack ? .leading : .trailing),
                            removal: .move(edge: isGoingBack ? .trailing : .leading)
                        ))
                case 1:
                    experienceStepView
                        .transition(.asymmetric(
                            insertion: .move(edge: isGoingBack ? .leading : .trailing),
                            removal: .move(edge: isGoingBack ? .trailing : .leading)
                        ))
                case 2:
                    scheduleStepView
                        .transition(.asymmetric(
                            insertion: .move(edge: isGoingBack ? .leading : .trailing),
                            removal: .move(edge: isGoingBack ? .trailing : .leading)
                        ))
                default:
                    nicknameStepView
                }
            }
            .padding(.horizontal, 24)
            .animation(.easeInOut(duration: 0.3), value: store.state.currentStep)
            
            bottomButtonView
                .padding(.horizontal, 24)
        }
        .background(DS.Colors.Background.white)
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom) // 키보드 영역 무시
        .onChange(of: store.state.isOnboardingCompleted) {
            if store.state.isOnboardingCompleted {
                // 온보딩 완료 알림 발송
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack {
            HStack(alignment: .center) {
                Button(action: {
                    isGoingBack = true
                    store.send(.goToPreviousStep)
                    
                    // 애니메이션 후 상태 리셋
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isGoingBack = false
                    }
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
            .frame(height: 56)
        }
    }
    
    private var nicknameStepView: some View {
        VStack {
            OnboardingStepView(
                title: "닉네임을 알려주세요!",
                subtitle: "언제든 변경할 수 있어요"
            ) {
                VStack(spacing: 24) {
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
                    
                    VStack(alignment: .leading) {
                        Text("생년월일")
                            .font(.subtitle1)
                            .foregroundColor(DS.Colors.Text.gray700)
                        
                        NWTextField.todoMultiLine(
                            text: Binding(
                                get: { store.state.birthDate },
                                set: { newValue in
                                    let filtered = newValue.filter { $0.isNumber }
                                    store.send(.updateBirthDate(filtered))
                                }
                            ),
                            placeholder: "예) 19900101",
                            errorMessage: Binding(
                                get: { store.state.birthDateError },
                                set: { _ in }
                            )
                        )
                    }
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
                    Text("\(store.state.displayRemainingDays)일 \(store.state.displayRemainingHours)시간")
                        .font(.heading2)
                        .foregroundColor(DS.Colors.Toast._500)
                        .padding(.vertical, 32)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("남은 연차")
                                .font(.subtitle1)
                                .foregroundColor(DS.Colors.Text.gray700)
                            
                            VStack(spacing: 24) {
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
                                
                                HStack {
                                    Text("반차도 남았어요.")
                                        .font(.body1)
                                        .foregroundColor(DS.Colors.Text.gray800) // 텍스트색상 변경
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: Binding(
                                        get: { store.state.hasHalfDay },
                                        set: { store.send(.updateHasHalfDay($0)) }
                                    ))
                                    .toggleStyle(SwitchToggleStyle(tint: DS.Colors.Neutral.black))
                                    .frame(width: 52)
                                }
                            }
                        }
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
                isGoingBack = false // 다음 버튼은 앞으로 가는 것이므로 false로 설정
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
