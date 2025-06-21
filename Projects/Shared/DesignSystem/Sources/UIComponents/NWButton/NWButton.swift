//
//  NWButton.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct NWButton<Content: View>: View {
    private let content: Content
    private let variant: NWButtonVariant
    private let size: NWButtonSize
    private let isEnabled: Bool
    private let action: () -> Void
    
    public init(
        title: String,
        variant: NWButtonVariant = .primary,
        size: NWButtonSize = .xl,
        action: @escaping () -> Void
    ) where Content == Text {
        self.content = Text(title)
        self.variant = variant
        self.size = size
        self.isEnabled = true
        self.action = action
    }
    
    public init(
        title: String,
        variant: NWButtonVariant,
        size: NWButtonSize = .xl,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) where Content == Text {
        self.content = Text(title)
        self.variant = variant
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public init(
        variant: NWButtonVariant = .primary,
        size: NWButtonSize = .xl,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.variant = variant
        self.size = size
        self.isEnabled = true
        self.action = action
    }
    
    public init(
        variant: NWButtonVariant,
        size: NWButtonSize = .xl,
        isEnabled: Bool,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.variant = variant
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }
    
    // MARK: - Body
    public var body: some View {
        Button(action: isEnabled ? action : {}) {
            content
        }
        .buttonStyle(NWButtonStyle(
            variant: variant,
            size: size,
            isEnabled: isEnabled
        ))
    }
}

// MARK: - Factory Methods
public extension NWButton where Content == Text {
    static func primary(
        _ title: String,
        size: NWButtonSize = .xl,
        action: @escaping () -> Void
    ) -> NWButton<Text> {
        NWButton(title: title, variant: .primary, size: size, action: action)
    }
    
    static func black(
        _ title: String,
        size: NWButtonSize = .xl,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> NWButton<Text> {
        NWButton(title: title, variant: .black, size: size, isEnabled: isEnabled, action: action)
    }
    
    static func outline(
        _ title: String,
        size: NWButtonSize = .xl,
        action: @escaping () -> Void
    ) -> NWButton<Text> {
        NWButton(title: title, variant: .outline, size: size, action: action)
    }
}
