//
//  OnboardingStepView.swift
//  Onboarding
//
//  Created by SiJongKim on 6/23/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct OnboardingStepView<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content
    
    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = nil
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.heading2)
                    .foregroundColor(DS.Colors.Neutral.black)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.gray700)
                }
            }
            
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct TagSelectionView: View {
    let selectedTags: Set<String>
    let onTagToggle: (String) -> Void
    
    private let tags = [
        ["출근", "퇴근", "회의 참석", "점심 식사 약속"],
        ["헬스장 운동", "카페에서 작업/휴식", "친구 만남"],
        ["술자리", "스터디", "학원 수업", "야근"],
        ["추가 업무", "산책", "반려동물 산책", "집안일"],
        ["은행 업무", "관공서 업무", "독서", "데이트"],
        ["미용실", "드라이브", "나들이", "넷플릭스 시청"],
        ["유튜브 시청", "치지직 시청"]
    ]
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            ForEach(0..<tags.count, id: \.self) { rowIndex in
                HStack(spacing: 8) {
                    ForEach(tags[rowIndex], id: \.self) { tag in
                        if !tag.isEmpty {
                            TagButton(
                                title: tag,
                                isSelected: selectedTags.contains(tag),
                                action: { onTagToggle(tag) }
                            )
                        } else {
                            Spacer()
                        }
                    }
                    
                    if tags[rowIndex].contains("") {
                        Spacer()
                    }
                }
            }
        }
    }
}

private struct TagButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subtitle1)
                .foregroundColor(isSelected ? DS.Colors.Neutral.black : DS.Colors.Text.gray700)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(DS.Colors.Neutral.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? DS.Colors.Toast._500 : DS.Colors.Border.gray200, lineWidth: 1)
                )
        }
    }
}
