//
//  KeyboardDismissalModifier.swift
//  DesignSystem
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import UIKit

public extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public struct KeyboardDismissalModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.dismissKeyboard()
            }
    }
}

public extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(KeyboardDismissalModifier())
    }
}
