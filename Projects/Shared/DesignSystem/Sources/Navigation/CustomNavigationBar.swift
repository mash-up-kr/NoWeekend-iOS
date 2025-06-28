//
//  CustomNavigationBar.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct CustomNavigationBar: View {
    public enum NavigationType {
        case backOnly
        case backWithLabel(String)
        case backWithLabelAndSave(String)
        case cancelWithLabelAndSave(String)
    }
    
    public let type: NavigationType
    public let onBackTapped: (() -> Void)?
    public let onCancelTapped: (() -> Void)?
    public let onSaveTapped: (() -> Void)?
    
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
            navigationContent
            centerLabel
        }
        .customNavigationBarStyle()
    }
}

private extension CustomNavigationBar {
    var navigationContent: some View {
        HStack {
            leftButtonContent
            Spacer()
            rightButtonContent
        }
    }
    
    @ViewBuilder
    var leftButtonContent: some View {
        switch type {
        case .backOnly, .backWithLabel, .backWithLabelAndSave:
            Button(action: { onBackTapped?() }) {
                Image(.icnChevronLeft)
            }
        case .cancelWithLabelAndSave:
            Button(action: { onCancelTapped?() }) {
                Text("취소")
                    .font(.heading6)
                    .foregroundColor(DS.Colors.Text.disable)
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
                .navigationTitleStyle()
        }
    }
    
    @ViewBuilder
    var rightButtonContent: some View {
        switch type {
        case .backOnly, .backWithLabel:
            Color.clear
                .frame(width: 60, height: 32)
        case .backWithLabelAndSave, .cancelWithLabelAndSave:
            Button(action: { onSaveTapped?() }) {
                Text("저장")
                    .font(.heading6)
                    .foregroundColor(DS.Colors.Toast._500)
            }
        }
    }
}

private extension View {
    func customNavigationBarStyle() -> some View {
        self
            .padding(.horizontal, 16)
            .frame(height: 56)
            .background(Color(.systemBackground))
    }
    
    func navigationTitleStyle() -> some View {
        self
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.primary)
    }
    
    func previewContainerStyle() -> some View {
        self.background(Color.gray.opacity(0.1))
    }
    
    func previewNavigationBarBackground() -> some View {
        self.background(Color.white)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 1) {
        // Back Only
        CustomNavigationBar(
            type: .backOnly,
            onBackTapped: { print("뒤로가기 tapped") }
        )
        .previewNavigationBarBackground()
        
        // Back with Label
        CustomNavigationBar(
            type: .backWithLabel("세부사항"),
            onBackTapped: { print("뒤로가기 tapped") }
        )
        .previewNavigationBarBackground()
        
        // Back with Label and Save
        CustomNavigationBar(
            type: .backWithLabelAndSave("프로필 편집"),
            onBackTapped: { print("뒤로가기 tapped") },
            onSaveTapped: { print("저장하기 tapped") }
        )
        .previewNavigationBarBackground()
        
        // Cancel with Label and Save
        CustomNavigationBar(
            type: .cancelWithLabelAndSave("새 게시물"),
            onCancelTapped: { print("취소 tapped") },
            onSaveTapped: { print("저장하기 tapped") }
        )
        .previewNavigationBarBackground()
    }
    .previewContainerStyle()
}
