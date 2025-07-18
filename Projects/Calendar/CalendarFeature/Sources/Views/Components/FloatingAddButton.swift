//
//  FloatingAddButton.swift
//  Feature
//
//  Created by 이지훈 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DesignSystem
import SwiftUI

struct FloatingAddButton: View {
    let isExpanded: Bool
    let isShowingCategory: Bool
    let action: () -> Void
    let dismissAction: (() -> Void)?
    
    @State private var isPressed = false
    
    init(
        isExpanded: Bool,
        isShowingCategory: Bool = false,
        action: @escaping () -> Void,
        dismissAction: (() -> Void)? = nil
    ) {
        self.isExpanded = isExpanded
        self.isShowingCategory = isShowingCategory
        self.action = action
        self.dismissAction = dismissAction
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                if isShowingCategory {
                    dismissAction?()
                } else {
                    action()
                }
            }
        }) {
            HStack(spacing: 8) {
                ZStack {
                    DS.Images.icnPlusWhite
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    DS.Images.icnXmark
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.black)
                        .scaleEffect(isShowingCategory ? 1 : 0)
                        .opacity(isShowingCategory ? 1 : 0)
                        .rotationEffect(.degrees(isShowingCategory ? 0 : -45))
                }
                .frame(width: 24, height: 24)
                
                if isExpanded && !isShowingCategory {
                    Text("할 일 추가")
                        .font(.heading6)
                        .foregroundStyle(.white)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
            }
            .frame(height: 56)
            .padding(.horizontal, buttonHorizontalPadding)
            .background(
                Group {
                    if isShowingCategory {
                        Circle()
                            .fill(Color.white)
                    } else {
                        Capsule()
                            .fill(Color.black)
                    }
                }
                .shadow(
                    color: .black.opacity(isPressed ? 0.3 : 0.15),
                    radius: isPressed ? 4 : 8,
                    x: 0,
                    y: isPressed ? 2 : 4
                )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isExpanded)
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isShowingCategory)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
    
    private var buttonHorizontalPadding: CGFloat {
        if isShowingCategory {
            return 16 // Circle 형태일 때: 56x56 크기 유지
        } else if isExpanded {
            return 20 // 텍스트 있을 때
        } else {
            return 16 // 아이콘만 있을 때
        }
    }
}
