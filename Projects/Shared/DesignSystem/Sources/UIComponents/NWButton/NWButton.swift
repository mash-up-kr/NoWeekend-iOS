//
//  NWButton.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct NWButton: View {
    private let title: String
    private let variant: NWButtonVariant
    private let size: NWButtonSize
    private let isEnabled: Bool
    private let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(NWButtonStyle(
            variant: variant,
            size: size,
            isEnabled: isEnabled
        ))
    }
}

public extension NWButton {
    static func primary(
        _ title: String,
        size: NWButtonSize = .xl,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> NWButton {
        NWButton(title: title, variant: .primary, size: size, isEnabled: isEnabled, action: action)
    }
    
    static func black(
        _ title: String,
        size: NWButtonSize = .xl,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> NWButton {
        NWButton(title: title, variant: .black, size: size, isEnabled: isEnabled, action: action)
    }
    
    static func outline(
        _ title: String,
        size: NWButtonSize = .xl,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> NWButton {
        NWButton(title: title, variant: .outline, size: size, isEnabled: isEnabled, action: action)
    }
}
