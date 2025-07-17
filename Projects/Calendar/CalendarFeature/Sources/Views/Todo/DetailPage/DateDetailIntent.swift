//
//  DateDetailIntent.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum DateDetailIntent {
    case loadSchedules
    case toggleTask(index: Int)
    case showTaskEditSheet(index: Int)
    case hideTaskEditSheet
    case editTask
    case tomorrowTask
    case deleteTask
    case showCategorySelection
    case hideCategorySelection
    case selectCategory(TaskCategory)
    case navigateToTaskCreate
    case taskCompletionToggled(Int)
}
