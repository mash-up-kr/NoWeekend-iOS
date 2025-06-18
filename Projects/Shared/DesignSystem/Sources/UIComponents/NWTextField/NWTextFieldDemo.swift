//
//  NWTextFieldDemo.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/18/25.
//

import SwiftUI

struct NWTextField_Demo: View {
    @State private var demoText = ""
    @State private var showError = false
    
    var body: some View {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("NWTextField 상태 데모")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("하나의 텍스트필드가 상황에 따라 다른 상태로 변합니다:")
                    .font(.body)
                    .foregroundColor(.gray)
                
                // 상태 설명
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Normal: 아무것도 입력하지 않은 상태")
                    Text("• Typing: 포커스되어 입력 중인 상태 (굵은 검은 테두리)")
                    Text("• Value: 값이 있는 상태 (placeholder가 위로 올라감)")
                    Text("• Error: 에러가 있는 상태 (빨간 테두리 + 에러 메시지)")
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                // 실제 텍스트필드
                NWTextField(
                    text: $demoText,
                    placeholder: "placeholder",
                    errorMessage: showError ? "invalid-feedback" : nil
                )
                
                // 컨트롤 버튼들
                VStack(spacing: 12) {
                    HStack {
                        Button("텍스트 클리어") {
                            demoText = ""
                            showError = false
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                        
                        Button("샘플 텍스트 입력") {
                            demoText = "2줄일때 이렇게 보여집니다. 2줄일때 이렇게 보여집니다. 2줄일때 이렇게 보여집니다."
                            showError = false
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                    }
                    
                    Toggle("에러 상태 표시", isOn: $showError)
                        .toggleStyle(SwitchToggleStyle())
                }
                
                // 현재 상태 표시
                VStack(alignment: .leading, spacing: 4) {
                    Text("현재 상태:")
                        .font(.caption)
                        .fontWeight(.bold)
                    
                    if showError {
                        Text("🔴 Error State")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else if demoText.isEmpty {
                        Text("⚪ Normal State")
                            .font(.caption)
                            .foregroundColor(.gray)
                    } else {
                        Text("🟢 Value State")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    
                    Text("입력된 텍스트: \"\(demoText)\"")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .background(DS.Colors.Background.gray100)
    }
}

struct NWTextField_Previews: PreviewProvider {
    static var previews: some View {
        NWTextField_Demo()
    }
}
