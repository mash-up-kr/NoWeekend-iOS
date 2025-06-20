//
//  BottomSheetContainer.swift
//  Shared
//
//  Created by 이지훈 on 6/20/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct BottomSheetContainer<Content: View>: View {
    public let height: CGFloat
    public let showDragIndicator: Bool
    public let cornerRadius: CGFloat
    public let horizontalPadding: CGFloat
    public let content: () -> Content
    
    public init(
        height: CGFloat = 400,
        showDragIndicator: Bool = true,
        cornerRadius: CGFloat = 16,
        horizontalPadding: CGFloat = 20,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.height = height
        self.showDragIndicator = showDragIndicator
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if showDragIndicator {
                CustomDragIndicator()
            }
            
            content()
                .padding(.horizontal, horizontalPadding)
            
            Spacer()
        }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(cornerRadius)
    }
}