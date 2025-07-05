//
//  FloatingAddButton.swift
//  Feature
//
//  Created by 이지훈 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FloatingAddButton: View {
    let isExpanded: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                DS.Images.icnPlus
                    .foregroundStyle(.white)
                
                if isExpanded {
                    Text("할 일 추가")
                        .font(.heading6)
                        .foregroundStyle(.white)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
            }
            .padding(.horizontal, isExpanded ? 20 : 16)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(Color.black)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0), value: isExpanded)
    }
}
