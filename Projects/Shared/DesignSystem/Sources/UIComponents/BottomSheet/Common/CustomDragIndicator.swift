//
//  CustomDragIndicator.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

internal struct CustomDragIndicator: View {
    public init() {}
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.4))
            .frame(width: 34, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .frame(height: 21)
    }
}
