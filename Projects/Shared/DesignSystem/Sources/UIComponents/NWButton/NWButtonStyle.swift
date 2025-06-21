//
//  NWButtonStyle.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/18/25.
//

import SwiftUI

public struct NWButtonStyle: ButtonStyle {
    private let variant: NWButtonVariant
    private let size: NWButtonSize
    private let isEnabled: Bool
    
    private var configuration: NWButtonConfiguration {
        NWButtonConfiguration.configuration(
            for: variant,
            size: size,
            isEnabled: isEnabled
        )
    }
    
    public init(
        variant: NWButtonVariant,
        size: NWButtonSize = .xl
    ) {
        self.variant = variant
        self.size = size
        self.isEnabled = true
    }
    
    public init(
        variant: NWButtonVariant,
        size: NWButtonSize = .xl,
        isEnabled: Bool
    ) {
        self.variant = variant
        self.size = size
        self.isEnabled = isEnabled
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(self.configuration.font)
            .foregroundColor(self.configuration.foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .background(self.configuration.backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(self.configuration.borderColor, lineWidth: self.configuration.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .allowsHitTesting(isEnabled)
    }
}
