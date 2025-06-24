//
//  NWTextFieldStyle.swift
//  DesignSystem
//
//  Created by 김시종 on 6/22/25.
//

import Foundation

public enum NWTextFieldStyle {
    case todoMultiLine
    case userInputTextField(String)
    
    public var hasClearButton: Bool {
        switch self {
        case .todoMultiLine:
            true
        case .userInputTextField:
            false
        }
    }
    
    public var suffixText: String? {
        switch self {
        case .todoMultiLine:
            return nil
        case .userInputTextField(let text):
            return text
        }
    }
}
