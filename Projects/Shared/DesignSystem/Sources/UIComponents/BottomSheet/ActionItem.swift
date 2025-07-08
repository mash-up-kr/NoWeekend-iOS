//
//  ActionList.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct ActionItem {
    public let image: Image?
    public let title: String
    public let textColor: Color
    public let action: () -> Void
    
    public init(
        image: Image? = nil,
        title: String,
        textColor: Color = DS.Colors.Text.netural,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.title = title
        self.textColor = textColor
        self.action = action
    }
}

public struct ActionList: View {
    public let items: [ActionItem]
    @Binding public var isPresented: Bool
    public let itemHeight: CGFloat
    
    public init(
        items: [ActionItem],
        isPresented: Binding<Bool>,
        itemHeight: CGFloat = 56
    ) {
        self.items = items
        self._isPresented = isPresented
        self.itemHeight = itemHeight
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                Button(action: {
                    item.action()
                    isPresented = false
                }) {
                    HStack(spacing: 8) {
                        if let image = item.image {
                            image
                        }
                        
                        Text(item.title)
                            .font(.body1)
                            .foregroundColor(item.textColor)
                        
                        Spacer()
                    }
                    .frame(height: itemHeight)
                }
            }
        }
    }
}
