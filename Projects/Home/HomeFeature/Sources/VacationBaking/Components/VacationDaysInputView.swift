//
//  VacationDaysInputView.swift
//  HomeFeature
//
//  Created by 김나희 on 7/11/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct VacationDaysInputView: View {
    let vacationDays: Int
    let remainingAnnualLeave: Int
    let errorMessage: String?
    let onDaysChanged: (String) -> Void
    
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 16) {
                NWTextField.userInputTextField(
                    text: $inputText,
                    suffixText: "일",
                    placeholder: "1일부터 15일 이내로 입력",
                    errorMessage: .constant(errorMessage),
                    keyboardType: .numberPad
                )
                .focused($isFocused)
                .onChange(of: inputText) { oldValue, newValue in
                    onDaysChanged(newValue)
                }
            }
            
            Spacer()
        }
        .onAppear {
            if vacationDays > 0 {
                inputText = "\(vacationDays)"
            }
        }
    }
} 
