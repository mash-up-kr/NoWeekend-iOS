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
        case .xl:
            return 60
        case .md:
            return 40
        }
    }
    
    var filledButtonFont: Font {
        switch self {
        case .xl: return .heading6
        case .md: return .subtitle1
        }
    }
    
    var outlineButtonFont: Font {
        switch self {
        case .xl: return .body1
        case .md: return .body1
        }
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
            return primaryConfiguration(size: size, isEnabled: isEnabled)
        case .black:
            return blackConfiguration(size: size, isEnabled: isEnabled)
        case .outline:
            return outlineConfiguration(size: size, isEnabled: isEnabled)
        }
    }
    
    private static func primaryConfiguration(size: NWButtonSize, isEnabled: Bool) -> NWButtonConfiguration {
        NWButtonConfiguration(
            backgroundColor: isEnabled ? DS.Colors.TaskItem.orange : DS.Colors.Neutral._300,
            foregroundColor: isEnabled ? DS.Colors.Neutral.white : DS.Colors.Neutral._500,
            borderColor: .clear,
            borderWidth: 0,
            font: size.filledButtonFont
        )
    }
    
    private static func blackConfiguration(size: NWButtonSize, isEnabled: Bool) -> NWButtonConfiguration {
        NWButtonConfiguration(
            backgroundColor: isEnabled ? DS.Colors.Neutral.black : DS.Colors.Neutral._300,
            foregroundColor: isEnabled ? DS.Colors.Neutral.white : DS.Colors.Neutral._500,
            borderColor: .clear,
            borderWidth: 0,
            font: size.filledButtonFont
        )
    }
    
    private static func outlineConfiguration(size: NWButtonSize, isEnabled: Bool) -> NWButtonConfiguration {
        NWButtonConfiguration(
            backgroundColor: DS.Colors.Background.white,
            foregroundColor: isEnabled ? DS.Colors.Neutral.black : DS.Colors.Neutral._400,
            borderColor: isEnabled ? DS.Colors.Border.gray300 : DS.Colors.Border.gray200,
            borderWidth: 1,
            font: size.outlineButtonFont
        )
    }
}
