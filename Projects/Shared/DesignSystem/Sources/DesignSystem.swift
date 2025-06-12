import SwiftUI
import Common

// MARK: - Typography
public struct Typography {
    public static let title = Font.largeTitle.weight(.bold)
    public static let headline = Font.headline.weight(.semibold)
    public static let body = Font.body
    public static let caption = Font.caption
}

// MARK: - Spacing
public struct Spacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
}

// MARK: - Colors
public struct Colors {
    public static let primary = Color.primaryColor
    public static let secondary = Color.secondaryColor
    public static let background = Color.backgroundColor
}
