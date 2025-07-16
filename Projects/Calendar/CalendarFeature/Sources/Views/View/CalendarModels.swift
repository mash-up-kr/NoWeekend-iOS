//
//  CalendarModels.swift
//  CalendarFeature
//
//  Created by Assistant on 7/12/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import DesignSystem
import Foundation
import SwiftUI
import Utils

// MARK: - Intent (사용자 액션)
public enum CalendarIntent {
    case viewDidAppear
    case toggleChanged(CalendarNavigationBar.ToggleOption)
    case dateSelected(Date)
    case dateDetailRequested(Date)
    case categorySelected(TaskCategory)
    case directInputTapped
    case taskEditRequested(Int)
    case taskTomorrowRequested(Int)
    case taskDeleteRequested(Int)
    case taskTitleChanged(Int, String)
    case categorySelectionToggled
    case scrollOffsetChanged(CGFloat, Bool)
    case taskCompletionToggled(Int)
    case taskMoreTapped(Int)
}

// MARK: - State (UI 상태)
public struct CalendarState: Equatable {
    var selectedDate = Date()
    var selectedToggle: CalendarNavigationBar.ToggleOption = .week
    var dailySchedules: [DailySchedule] = []
    var todoItems: [DesignSystem.TodoItem] = []
    var recommendedCategories: [TaskCategory] = [] 
    
    var showDatePicker = false
    var showTaskEditSheet = false
    var showCategorySelection = false
    var scrollOffset: CGFloat = 0
    var isScrolling = false
    
    var selectedTaskIndex: Int?
    var editingTaskIndex: Int?
    var isLoading = false
    
    var isFloatingButtonExpanded: Bool {
        scrollOffset == 0 && !isScrolling
    }
    
    var currentDateString: String {
        selectedDate.toString(format: "yyyy년 M월")
    }
    
    public static func == (lhs: CalendarState, rhs: CalendarState) -> Bool {
        lhs.selectedDate == rhs.selectedDate &&
        lhs.selectedToggle == rhs.selectedToggle &&
        lhs.dailySchedules.count == rhs.dailySchedules.count &&
        lhs.todoItems.count == rhs.todoItems.count &&
        lhs.recommendedCategories.count == rhs.recommendedCategories.count &&
        lhs.showDatePicker == rhs.showDatePicker &&
        lhs.showTaskEditSheet == rhs.showTaskEditSheet &&
        lhs.showCategorySelection == rhs.showCategorySelection &&
        lhs.isLoading == rhs.isLoading
    }
}

// MARK: - Effect
public enum CalendarEffect {
    case navigateToTaskCreate(Date)
    case navigateToTaskEdit(Int, String, String?, String?, Date)
    case navigateToDateDetail(Date)
    case showError(String)
    case showSuccess(String)
}

// MARK: - Domain Extensions
extension DailySchedule {
    var dailyTemperature: Int {
        guard !schedules.isEmpty else { return 0 }
        let totalTemperature = schedules.reduce(0) { $0 + $1.temperature }
        return totalTemperature / schedules.count
    }
}

extension ScheduleCategory {
    var designSystemColor: Color {
        switch self {
        case .company: return DS.Colors.TaskItem.green
        case .personal: return DS.Colors.TaskItem.orange
        case .leave: return DS.Colors.TaskItem.purple
        case .etc: return DS.Colors.TaskItem.etc
        }
    }
}
