//
//  NWButtonSize.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public enum NWButtonSize {
    case xl
    case md
    
    public var height: CGFloat {
        switch self {
        case .xl: return 60
        case .md: return 40
        }
    }
    
    var filledButtonFont: Font {
        return .heading6
    }
    
    var outlineButtonFont: Font {
        return .body1
    }
}

public enum NWButtonVariant {
    case primary
    case black
    case outline
}

public struct NWButtonConfiguration {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let font: Font
    
    static func configuration(
        for variant: NWButtonVariant,
        size: NWButtonSize,
        isEnabled: Bool
    ) -> NWButtonConfiguration {
        switch variant {
        case .primary:
            return primaryConfiguration(size: size)
        case .black:
            return blackConfiguration(size: size, isEnabled: isEnabled)
        case .outline:
            return outlineConfiguration(size: size)
        }
    }
    
    private static func primaryConfiguration(size: NWButtonSize) -> NWButtonConfiguration {
        NWButtonConfiguration(
            backgroundColor: DS.Colors.TaskItem.orange,
            foregroundColor: DS.Colors.Neutral.white,
            borderColor: .clear,
            borderWidth: 0,
            font: size.filledButtonFont
        )
    }
    
    private static func blackConfiguration(size: NWButtonSize, isEnabled: Bool) -> NWButtonConfiguration {
        NWButtonConfiguration(
            backgroundColor: isEnabled ? DS.Colors.Neutral.black : DS.Colors.Neutral._700,
            foregroundColor: DS.Colors.Neutral.white,
            borderColor: .clear,
            borderWidth: 0,
            font: size.filledButtonFont
        )
    }
    
    private static func outlineConfiguration(size: NWButtonSize) -> NWButtonConfiguration {
        NWButtonConfiguration(
            backgroundColor: DS.Colors.Background.white,
            foregroundColor: DS.Colors.Neutral.black,
            borderColor: DS.Colors.Border.gray300,
            borderWidth: 1,
            font: size.outlineButtonFont
        )
    }
}
