//
//  CustomNavigationBar.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

// MARK: - Custom Navigation Component
public struct CustomNavigationBar: View {
    public enum NavigationType {
        case backOnly
        case backWithLabel(String)
        case backWithLabelAndSave(String)
        case cancelWithLabelAndSave(String)
    }
    
    let type: NavigationType
    let onBackTapped: (() -> Void)?
    let onCancelTapped: (() -> Void)?
    let onSaveTapped: (() -> Void)?
    
    public init(
        type: NavigationType,
        onBackTapped: (() -> Void)? = nil,
        onCancelTapped: (() -> Void)? = nil,
        onSaveTapped: (() -> Void)? = nil
    ) {
        self.type = type
        self.onBackTapped = onBackTapped
        self.onCancelTapped = onCancelTapped
        self.onSaveTapped = onSaveTapped
    }
    
    public var body: some View {
        ZStack {
            HStack {
                leftButton
                
                Spacer()
                
                rightButton
            }
            
            centerLabel
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Color(.systemBackground))
    }
}

// MARK: - Private Views
private extension CustomNavigationBar {
    @ViewBuilder
    var leftButton: some View {
        switch type {
        case .backOnly, .backWithLabel, .backWithLabelAndSave:
            Button(action: {
                onBackTapped?()
            }) {
                Image(.icnChevronLeft)
            }
            
        case .cancelWithLabelAndSave:
            Button(action: {
                onCancelTapped?()
            }) {
                Text("취소")
                    .font(.heading6)
                    .foregroundColor(DS.Colors.Text.gray700)
            }
        }
    }
    
    @ViewBuilder
    var centerLabel: some View {
        switch type {
        case .backOnly:
            EmptyView()
            
        case .backWithLabel(let title),
             .backWithLabelAndSave(let title),
             .cancelWithLabelAndSave(let title):
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    var rightButton: some View {
        switch type {
        case .backOnly, .backWithLabel:
            Color.clear
                .frame(width: 60, height: 32)
            
        case .backWithLabelAndSave, .cancelWithLabelAndSave:
            Button(action: {
                onSaveTapped?()
            }) {
                Text("저장")
                    .font(.heading6)
                        .foregroundColor(DS.Colors.Toast._500)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 1) {
        // 1. 뒤로가기만 있는 버전
        CustomNavigationBar(
            type: .backOnly,
            onBackTapped: {
                print("뒤로가기 tapped")
            }
        )
        .background(Color.white)
        
        // 2. 뒤로가기 + 가운데 레이블
        CustomNavigationBar(
            type: .backWithLabel("세부사항"),
            onBackTapped: {
                print("뒤로가기 tapped")
            }
        )
        .background(Color.white)
        
        // 3. 뒤로가기 + 가운데 레이블 + 저장하기 버튼
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
        
        // 4. 취소 + 가운데 레이블 + 저장하기 버튼
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
    }
    .background(Color.gray.opacity(0.1))
}
