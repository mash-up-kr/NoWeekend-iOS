//
//  NWButtonStyle.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/18/25.
//

import SwiftUI

public struct NWButtonStyle: ButtonStyle {
    private let configuration: NWButtonConfiguration
    private let size: NWButtonSize
    private let isEnabled: Bool
    
    public init(
        variant: NWButtonVariant,
        size: NWButtonSize,
        isEnabled: Bool
    ) {
        self.configuration = NWButtonConfiguration.configuration(
            for: variant,
            size: size,
            isEnabled: isEnabled
        )
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
