//
//  NWTextFieldTest.swift
//  DesignSystem
//
//  Created by 김시종 on 6/19/25.
//

import SwiftUI

public struct NWTextFieldTest: View {
    @State private var normalText = ""
    @State private var errorText = "입력된 텍스트"
    @State private var longText = "이것은 매우 긴 텍스트입니다. 여러 줄로 표시될 정도로 긴 텍스트를 입력해서 멀티라인 상태에서의 X 버튼 위치와 전체적인 레이아웃을 확인할 수 있도록 작성했습니다."
    
    @State private var normalError: String? = nil
    @State private var withError: String? = "에러 메시지가 표시됩니다"
    @State private var longError: String? = nil
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // 1. 일반 상태 (비어있음)
                VStack(alignment: .leading, spacing: 8) {
                    Text("일반 상태 (Normal)")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    NWTextField(
                        text: $normalText,
                        placeholder: "텍스트를 입력하세요",
                        errorMessage: $normalError
                    )
                }
                
                Spacer()
                
                // 2. 에러 상태
                VStack(alignment: .leading, spacing: 8) {
                    Text("에러 상태 (Error)")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    NWTextField(
                        text: $errorText,
                        placeholder: "텍스트를 입력하세요",
                        errorMessage: $withError
                    )
                }
                
                Spacer()
                
                // 3. 멀티라인 상태
                VStack(alignment: .leading, spacing: 8) {
                    Text("멀티라인 상태 (Multi-line)")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    NWTextField(
                        text: $longText,
                        placeholder: "긴 텍스트를 입력하세요",
                        errorMessage: $longError
                    )
                }
                
                Spacer()
                
                // 4. 테스트 버튼들
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
                            normalText = ""
                            errorText = ""
                            longText = ""
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(DS.Colors.Neutral._100)
                        .foregroundColor(DS.Colors.Text.gray900)
                        .cornerRadius(8)
                    }
                    
                    HStack(spacing: 12) {
                        Button("샘플 텍스트 추가") {
                            normalText = "일반 텍스트"
                            errorText = "에러가 있는 텍스트"
                            longText = "이것은 매우 긴 텍스트입니다. 여러 줄로 표시될 정도로 긴 텍스트를 입력해서 멀티라인 상태를 테스트할 수 있습니다."
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
