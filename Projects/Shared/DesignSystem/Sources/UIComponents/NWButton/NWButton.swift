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
    
    private var configuration: NWButtonConfiguration {
        NWButtonConfiguration.configuration(
            for: variant,
            size: size,
            isEnabled: isEnabled
        )
    }
    
    public init(
        title: String,
        variant: NWButtonVariant = .primary,
        size: NWButtonSize = .xl,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(configuration.font)
                .foregroundColor(configuration.foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: size.height)
                .background(configuration.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(configuration.borderColor, lineWidth: configuration.borderWidth)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
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
