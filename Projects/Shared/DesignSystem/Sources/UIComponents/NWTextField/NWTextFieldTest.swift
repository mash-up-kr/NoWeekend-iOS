//
//  NWTextFieldTest.swift
//  DesignSystem
//
//  Created by 김시종 on 6/19/25.
//

import SwiftUI

public struct NWTextFieldTest: View {
    @State private var standardText = ""
    @State private var dayText = ""
    @State private var timeText = ""
    @State private var errorText = "입력된 텍스트"
    
    @State private var standardError: String? = nil
    @State private var dayError: String? = nil
    @State private var timeError: String? = nil
    @State private var withError: String? = "에러 메시지가 표시됩니다"
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // 1. Standard 스타일 (X 버튼)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Standard 스타일 (X 버튼)")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    NWTextField.todoMultiLine(
                        text: $standardText,
                        placeholder: "텍스트를 입력하세요",
                        errorMessage: $standardError
                    )
                }
                
                Spacer()
                
                // 2. Suffix 스타일 - 일
                VStack(alignment: .leading, spacing: 8) {
                    Text("Suffix 스타일 - 일")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    NWTextField.userInputTextField(
                        text: $dayText,
                        suffixText: "일",
                        placeholder: "0",
                        errorMessage: $dayError
                    )
                }
                
                Spacer()
                
                // 3. Suffix 스타일 - 시간
                VStack(alignment: .leading, spacing: 8) {
                    Text("Suffix 스타일 - 시간")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    NWTextField.userInputTextField(
                        text: $timeText,
                        suffixText: "시간",
                        placeholder: "0",
                        errorMessage: $timeError
                    )
                }
                
                Spacer()
                
                // 4. 체이닝 방식 사용 예시
                VStack(alignment: .leading, spacing: 8) {
                    Text("체이닝 방식 (에러 상태)")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    NWTextField(text: $errorText)
                        .placeholder("텍스트를 입력하세요")
                        .suffix("분")
                        .errorMessage(withError)
                }
                
                Spacer()
                
                // 5. 테스트 버튼들
                VStack(alignment: .leading, spacing: 12) {
                    Text("테스트 액션")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    HStack(spacing: 12) {
                        Button("에러 토글") {
                            if withError != nil {
                                withError = nil
                            } else {
                                withError = "에러 메시지가 표시됩니다"
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(DS.Colors.Neutral._100)
                        .foregroundColor(DS.Colors.Text.gray900)
                        .cornerRadius(8)
                        
                        Button("텍스트 초기화") {
                            standardText = ""
                            dayText = ""
                            timeText = ""
                            errorText = ""
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(DS.Colors.Neutral._100)
                        .foregroundColor(DS.Colors.Text.gray900)
                        .cornerRadius(8)
                    }
                    
                    HStack(spacing: 12) {
                        Button("샘플 데이터 입력") {
                            standardText = "일반 텍스트"
                            dayText = "15"
                            timeText = "8"
                            errorText = "30"
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(DS.Colors.Neutral._100)
                        .foregroundColor(DS.Colors.Text.gray900)
                        .cornerRadius(8)
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(20)
        }
    }
}

#Preview {
    NWTextFieldTest()
}
