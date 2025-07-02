//
//  ValidationResult.swift
//  CalendarInterface
//
//  Created by SiJongKim on 7/2/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum ValidationResult {
    case valid
    case invalid(String)
    
    public var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    public var errorMessage: String? {
        switch self {
        case .valid:
            return nil
        case .invalid(let message):
            return message
        }
    }
}
