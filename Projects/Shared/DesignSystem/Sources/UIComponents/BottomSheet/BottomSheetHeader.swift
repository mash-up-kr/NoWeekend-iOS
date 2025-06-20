//
//  BottomSheetHeader.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct BottomSheetHeader: View {
    public let title: String?
    public let subtitle: String?
    public let alignment: TextAlignment
    public let topPadding: CGFloat
    public let bottomPadding: CGFloat
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        alignment: TextAlignment = .center,
        topPadding: CGFloat = 24,
        bottomPadding: CGFloat = 20
    ) {
        self.title = title
        self.subtitle = subtitle
        self.alignment = alignment
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
    }
    
    public var body: some View {
        VStack(spacing: 4) {
            if let title = title {
                Text(title)
                    .font(.heading4)
                    .foregroundColor(.black)
                    .multilineTextAlignment(alignment)
            }
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(alignment)
            }
        }
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
    }
}
