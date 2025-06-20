//
//  NavigationExampleView.swift
//  Shared
//
//  Created by 이지훈 on 6/19/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

// MARK: - All Navigation Bars Preview
public struct NavigationExampleView: View {
    @State private var selectedToggle: CalendarNavigationBar.ToggleOption = .week
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 1) {
            // 1. 캘린더 네비게이션 바
            CalendarNavigationBar(
                onDateTapped: {
                    print("날짜 버튼 클릭")
                },
                onToggleChanged: { toggle in
                    print("토글 변경: \(toggle.rawValue)")
                }
            )
            .background(Color.white)
            
            // 2. 뒤로가기만
            CustomNavigationBar(
                type: .backOnly,
                onBackTapped: {
                    print("뒤로가기 tapped")
                }
            )
            .background(Color.white)
            
            // 3. 뒤로가기 + 레이블
            CustomNavigationBar(
                type: .backWithLabel("세부사항"),
                onBackTapped: {
                    print("뒤로가기 tapped")
                }
            )
            .background(Color.white)
            
            // 4. 뒤로가기 + 레이블 + 저장
            CustomNavigationBar(
                type: .backWithLabelAndSave("프로필 편집"),
                onBackTapped: {
                    print("뒤로가기 tapped")
                },
                onSaveTapped: {
                    print("저장하기 tapped")
                }
            )
            .background(Color.white)
            
            // 5. 취소 + 레이블 + 저장
            CustomNavigationBar(
                type: .cancelWithLabelAndSave("새 게시물"),
                onCancelTapped: {
                    print("취소 tapped")
                },
                onSaveTapped: {
                    print("저장하기 tapped")
                }
            )
            .background(Color.white)
            
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}

// MARK: - Preview
#Preview {
    NavigationExampleView()
}
