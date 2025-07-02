//
//  ToastTemperature.swift
//  Calendar
//
//  Created by 김나희 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

/// 열정온도
enum ToastTemperature: Int {
    case cold, warm, hot, burnt

    init(value: Int) {
        switch value {
        case 0: self = .cold
        case 1...25: self = .warm
        case 26...50: self = .hot
        default: self = .burnt
        }
    }

    var cardImage: Image {
        switch self {
        case .cold: DS.Images.Todo.breadCold
        case .warm: DS.Images.Todo.breadWarm
        case .hot: DS.Images.Todo.breadHot
        case .burnt: DS.Images.Todo.breadBurnt
        }
    }
    
    var text: String {
        switch self {
        case .cold: "연차라서 열정 온도"
        default: "오늘의 열정 온도"
        }
    }
    
    var textColor: Color {
        switch self {
        case .cold: DS.Colors.TaskItem.purple
        case .warm: DS.Colors.Toast._500
        case .hot: DS.Colors.Toast._700
        case .burnt: DS.Colors.Toast._900
        }
    }
}
