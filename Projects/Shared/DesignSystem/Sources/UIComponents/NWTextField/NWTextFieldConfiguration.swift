//
//  NWTextFieldState.swift
//  DesignSystem
//
//  Created by SiJongKim on 6/18/25.
//

import SwiftUI

public enum NWTextFieldState {
    case normal
    case typing
    case typingError
    
    var borderColor: Color {
        switch self {
        case .normal:
            return DS.Colors.Border.gray300
        case .typing:
            return DS.Colors.Neutral.black
        case .typingError:
            return DS.Colors.TaskItem.orange // 수정해야함 primary 700, 텍스트는 500
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .normal:
            return 1
        case .typing:
            return 2
        case .typingError:
            return 1
        }
    }
}

