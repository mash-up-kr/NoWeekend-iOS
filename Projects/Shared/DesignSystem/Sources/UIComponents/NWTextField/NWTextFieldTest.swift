//
//  NWTextFieldTest.swift
//  DesignSystem
//
//  Created by 김시종 on 6/19/25.
//

import SwiftUI

public struct NWTextFieldExample: View {
    
    // MARK: - State Properties
    @State private var todoText = ""
    @State private var daysText = ""
    @State private var hoursText = ""
    @State private var minutesText = ""
    
    @State private var todoError: String?
    @State private var daysError: String?
    
    public init() {}
    
    // MARK: - Body
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                basicUsageSection
                
                suffixStyleSection
                
                errorStateSection
                
                chainingSyntaxSection
            }
            .padding(20)
        }
        .navigationTitle("NWTextField")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var basicUsageSection: some View {
        ExampleSection(title: "기본 사용법", description: "멀티라인 텍스트 입력이 가능한 기본 스타일") {
            NWTextField.todoMultiLine(
                text: $todoText,
                placeholder: "할 일을 입력하세요",
                errorMessage: $todoError
            )
        }
    }
    
    private var suffixStyleSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            VStack(alignment: .leading, spacing: 16) {
                ExampleSubSection(label: "일 단위 입력") {
                    NWTextField.userInputTextField(
                        text: $daysText,
                        suffixText: "일",
                        placeholder: "0",
                        errorMessage: $daysError
                    )
                }
                
                ExampleSubSection(label: "시간 단위 입력") {
                    NWTextField.userInputTextField(
                        text: $hoursText,
                        suffixText: "시간",
                        placeholder: "0"
                    )
                }
            }
        }
    }
    
    private var errorStateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 12) {
                NWTextField.userInputTextField(
                    text: .constant("잘못된 값"),
                    suffixText: "일",
                    placeholder: "0",
                    errorMessage: .constant("1일 이상 입력해주세요")
                )
                
                Text("에러가 있을 때 border 색상과 두께가 변경됩니다.")
                    .font(.caption)
                    .foregroundColor(DS.Colors.Text.disable)
            }
        }
    }
    
    private var chainingSyntaxSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                NWTextField(text: $minutesText)
                    .placeholder("분 단위를 입력하세요")
                    .suffix("분")
                
            }
        }
    }
}

// MARK: - Supporting Views
private struct ExampleSection<Content: View>: View {
    let title: String
    let description: String
    let content: Content
    
    init(title: String, description: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.description = description
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(DS.Colors.Text.netural)
                
                Text(description)
                    .font(.body2)
                    .foregroundColor(DS.Colors.Text.disable)
            }
            
            content
        }
    }
}

private struct ExampleSubSection<Content: View>: View {
    let label: String
    let content: Content
    
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.body2)
                .fontWeight(.medium)
                .foregroundColor(DS.Colors.Text.disable)
            
            content
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        NWTextFieldExample()
    }
}
