//
//  NWInputSections.swift (기존 기능 그대로 컴포넌트화)
//  DesignSystem
//
//  Created by SiJongKim on 7/4/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

// MARK: - 닉네임 입력 섹션 컴포넌트

public struct NWNicknameInputSection: View {
    @Binding private var nickname: String
    private let nicknameError: String?
    
    public init(
        nickname: Binding<String>,
        nicknameError: String?
    ) {
        self._nickname = nickname
        self.nicknameError = nicknameError
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("닉네임")
                .font(.subtitle1)
                .foregroundColor(DS.Colors.Text.disable)
            
            NWTextField.todoMultiLine(
                text: $nickname,
                placeholder: "최대 6글자",
                errorMessage: Binding(
                    get: { nicknameError },
                    set: { _ in }
                )
            )
        }
    }
}

// MARK: - 생년월일 입력 섹션 컴포넌트

public struct NWBirthDateInputSection: View {
    @Binding private var birthDate: String
    private let birthDateError: String?
    
    public init(
        birthDate: Binding<String>,
        birthDateError: String?
    ) {
        self._birthDate = birthDate
        self.birthDateError = birthDateError
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("생년월일")
                .font(.subtitle1)
                .foregroundColor(DS.Colors.Text.disable)
            
            NWTextField.todoMultiLine(
                text: $birthDate,
                placeholder: "예) 19900101",
                errorMessage: Binding(
                    get: { birthDateError },
                    set: { _ in }
                )
            )
            
            Text("생일 맞춤 일정을 위해 생년월일이 필요합니다.")
                .font(.body3)
                .foregroundColor(DS.Colors.Text.disable)
        }
    }
}

// MARK: - 연차 표시 섹션 컴포넌트

public struct NWRemainingDaysDisplaySection: View {
    private let displayDays: String
    private let displayHours: String
    
    public init(
        displayDays: String,
        displayHours: String
    ) {
        self.displayDays = displayDays
        self.displayHours = displayHours
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Text("\(displayDays)일 \(displayHours)시간")
                .font(.heading2)
                .foregroundColor(DS.Colors.Toast._500)
                .padding(.vertical, 32)
        }
    }
}

// MARK: - 연차 입력 섹션 컴포넌트

public struct NWRemainingDaysInputSection: View {
    @Binding private var remainingDays: String
    private let remainingDaysError: String?
    @Binding private var hasHalfDay: Bool
    
    public init(
        remainingDays: Binding<String>,
        remainingDaysError: String?,
        hasHalfDay: Binding<Bool>
    ) {
        self._remainingDays = remainingDays
        self.remainingDaysError = remainingDaysError
        self._hasHalfDay = hasHalfDay
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("남은 연차")
                .font(.subtitle1)
                .foregroundColor(DS.Colors.Text.disable)
            
            VStack(spacing: 24) {
                NWTextField.userInputTextField(
                    text: $remainingDays,
                    suffixText: "일",
                    placeholder: "0",
                    errorMessage: Binding(
                        get: { remainingDaysError },
                        set: { _ in }
                    )
                )
                
                HStack {
                    Text("반차도 남았어요.")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.netural)
                    
                    Spacer()
                    
                    Toggle("", isOn: $hasHalfDay)
                        .toggleStyle(SwitchToggleStyle(tint: DS.Colors.Neutral.black))
                        .frame(width: 52)
                }
            }
        }
    }
}
