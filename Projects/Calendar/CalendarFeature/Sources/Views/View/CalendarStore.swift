//
//  CalendarStore.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/12/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import Combine
import DesignSystem
import DIContainer
import Foundation
import SwiftUI
import Utils

public final class CalendarStore: ObservableObject {
    @Dependency private var calendarUseCase: CalendarUseCaseProtocol
    
    @Published public private(set) var state = CalendarState()
    private let effectSubject = PassthroughSubject<CalendarEffect, Never>()
    
    public var effect: AnyPublisher<CalendarEffect, Never> {
        effectSubject.eraseToAnyPublisher()
    }
    
    public init() {}
    
    public func send(_ intent: CalendarIntent) {
        Task { @MainActor in
            await handle(intent)
        }
    }
    
    @MainActor
    internal func updateState(_ update: (inout CalendarState) -> Void) {
        update(&state)
    }
    
    @MainActor
    private func handle(_ intent: CalendarIntent) async {
        switch intent {
        case .viewDidAppear:
            await handleViewDidAppear()
        case .toggleChanged(let toggle):
            await handleToggleChanged(toggle)
        case .dateSelected(let date):
            await handleDateSelected(date)
        case .dateDetailRequested(let date):
            handleDateDetailRequested(date)
        case .categorySelected(let category):
            handleCategorySelected(category)
        case .directInputTapped:
            handleDirectInputTapped()
        case .taskEditRequested(let index):
            handleTaskEditRequested(index)
        case .taskTomorrowRequested(let index):
            await handleTaskTomorrowRequested(index)
        case .taskDeleteRequested(let index):
            await handleTaskDeleteRequested(index)
        case .taskTitleChanged(let index, let newTitle):
            await handleTaskTitleChanged(index: index, newTitle: newTitle)
        case .categorySelectionToggled:
            handleCategorySelectionToggled()
        case .scrollOffsetChanged(let offset, let isScrolling):
            handleScrollOffsetChanged(offset: offset, isScrolling: isScrolling)
        case .taskCompletionToggled(let index):
            await handleTaskCompletionToggled(index)
        case .taskMoreTapped(let index):
            handleTaskMoreTapped(index)
        }
    }
}

// MARK: - Intent Handlers
private extension CalendarStore {
    @MainActor
    func handleViewDidAppear() async {
        state.scrollOffset = 0
        await loadRecommendedCategories()
        await loadSchedules()
        updateTodoItemsForSelectedDate()
    }
    
    @MainActor
    func handleToggleChanged(_ toggle: CalendarNavigationBar.ToggleOption) async {
        state.selectedToggle = toggle
        await loadSchedules()
        updateTodoItemsForSelectedDate()
    }
    
    @MainActor
    func handleDateSelected(_ date: Date) async {
        state.selectedDate = date
        
        if state.selectedToggle == .month {
            effectSubject.send(.navigateToDateDetail(date))
        } else {
            await loadSchedules()
            updateTodoItemsForSelectedDate()
        }
    }
    
    @MainActor
    func handleDateDetailRequested(_ date: Date) {
        effectSubject.send(.navigateToDateDetail(date))
    }
    
    @MainActor
    func handleCategorySelected(_ category: TaskCategory) {
        Task {
            await createScheduleFromCategory(category)
        }
        
        state.showCategorySelection = false
    }
    
    @MainActor
    func handleDirectInputTapped() {
        state.showCategorySelection = false
        effectSubject.send(.navigateToTaskCreate(state.selectedDate))
    }
    
    @MainActor
    func handleTaskMoreTapped(_ index: Int) {
        guard index < state.todoItems.count else { return }
        
        state.selectedTaskIndex = index
        state.showTaskEditSheet = true
    }
    
    @MainActor
    func handleTaskEditRequested(_ index: Int) {
        state.showTaskEditSheet = false
        
        guard index < state.todoItems.count else { return }
        let todoItem = state.todoItems[index]
        
        effectSubject.send(.navigateToTaskEdit(
            todoItem.id,
            todoItem.title,
            todoItem.category?.name,
            todoItem.scheduleId,
            state.selectedDate
        ))
    }
    
    @MainActor
    func handleTaskTomorrowRequested(_ index: Int) async {
        state.showTaskEditSheet = false
        
        guard index < state.todoItems.count else { return }
        let todoItem = state.todoItems[index]
        
        guard todoItem.category?.name != "연차" else { return }
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: state.selectedDate) ?? state.selectedDate
        
        do {
            let tomorrowStartTime = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
            let tomorrowEndTime = Calendar.current.date(byAdding: .hour, value: 1, to: tomorrowStartTime) ?? tomorrowStartTime
            
            let scheduleCategory = mapCategoryNameToScheduleCategory(todoItem.category?.name ?? "기타")
            
            _ = try await calendarUseCase.createSchedule(
                title: todoItem.title,
                date: tomorrow,
                startTime: tomorrowStartTime,
                endTime: tomorrowEndTime,
                category: scheduleCategory,
                temperature: 50,
                allDay: false,
                alarmOption: .none
            )
            
            effectSubject.send(.showSuccess("내일 할 일로 추가되었습니다"))
            
        } catch {
            effectSubject.send(.showError("내일 할 일 추가에 실패했습니다"))
        }
    }
    
    @MainActor
    func handleTaskDeleteRequested(_ index: Int) async {
        state.showTaskEditSheet = false
        
        guard index < state.todoItems.count else { return }
        
        let todoItem = state.todoItems[index]
        
        guard let scheduleId = todoItem.scheduleId else {
            state.todoItems.remove(at: index)
            state.selectedTaskIndex = nil
            return
        }
        
        do {
            try await calendarUseCase.deleteSchedule(id: scheduleId)
            state.todoItems.remove(at: index)
            state.selectedTaskIndex = nil
            await loadSchedules()
        } catch {
            effectSubject.send(.showError("일정 삭제에 실패했습니다."))
        }
    }
    
    @MainActor
    func handleTaskTitleChanged(index: Int, newTitle: String) async {
        guard index < state.todoItems.count else { return }
        state.todoItems[index].title = newTitle
    }
    
    @MainActor
    func handleCategorySelectionToggled() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            state.showCategorySelection.toggle()
        }
    }
    
    @MainActor
    func handleScrollOffsetChanged(offset: CGFloat, isScrolling: Bool) {
        state.scrollOffset = offset
        state.isScrolling = isScrolling
    }
}

// MARK: - Business Logic
private extension CalendarStore {
    @MainActor
    func loadSchedules() async {
        state.isLoading = true
        
        do {
            let schedules = try await fetchSchedules()
            state.dailySchedules = schedules
            state.isLoading = false
            updateTodoItemsForSelectedDate()
        } catch {
            state.todoItems = []
            state.isLoading = false
        }
    }
    
    @MainActor
    func loadRecommendedCategories() async {
        do {
            let response = try await calendarUseCase.getRecommendedTags()
            
            if response.result == "SUCCESS", let data = response.data {
                state.recommendedCategories = [
                    TaskCategory(name: data.firstRecommendTag.content, color: DS.Colors.TaskItem.green),
                    TaskCategory(name: data.secondRecommendTag.content, color: DS.Colors.TaskItem.orange),
                    TaskCategory(name: data.thirdRecommendTag.content, color: DS.Colors.Neutral.gray700)
                ]
            } else {
                state.recommendedCategories = getDefaultCategories()
            }
        } catch {
            state.recommendedCategories = getDefaultCategories()
            print("추천 카테고리 로딩 실패: \(error)")
        }
    }
    
    func getDefaultCategories() -> [TaskCategory] {
        return [
            TaskCategory(name: "출근하기", color: DS.Colors.TaskItem.green),
            TaskCategory(name: "운동하기", color: DS.Colors.TaskItem.orange),
            TaskCategory(name: "선물사기", color: DS.Colors.Neutral.gray700)
        ]
    }
    
    func fetchSchedules() async throws -> [DailySchedule] {
        switch state.selectedToggle {
        case .week:
            let (startDate, endDate) = calculateWeekRange(for: state.selectedDate)
            return try await calendarUseCase.getSchedulesForDateRange(startDate: startDate, endDate: endDate)
        case .month:
            let (startDate, endDate) = calculateMonthRange(for: state.selectedDate)
            return try await calendarUseCase.getSchedulesForDateRange(startDate: startDate, endDate: endDate)
        }
    }
    
    @MainActor
    func updateTodoItemsForSelectedDate() {
        let selectedDateString = state.selectedDate.toString(format: "yyyy-MM-dd")
        
        if let daySchedule = state.dailySchedules.first(where: { $0.date == selectedDateString }) {
            let todoItemsFromAPI = daySchedule.schedules.enumerated().map { index, schedule in
                createTodoFromSchedule(id: index + 1, schedule: schedule)
            }
            state.todoItems = todoItemsFromAPI
        } else {
            state.todoItems = []
        }
    }
    
    func calculateWeekRange(for date: Date) -> (Date, Date) {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return (date, date)
        }
        return (weekInterval.start, calendar.date(byAdding: .day, value: -1, to: weekInterval.end) ?? weekInterval.end)
    }
    
    func calculateMonthRange(for date: Date) -> (Date, Date) {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: date) else {
            return (date, date)
        }
        
        let firstDayOfMonth = monthInterval.start
        let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: monthInterval.end) ?? monthInterval.end
        
        guard let firstWeekStart = calendar.dateInterval(of: .weekOfYear, for: firstDayOfMonth)?.start else {
            return (firstDayOfMonth, lastDayOfMonth)
        }
        
        guard let lastWeekInterval = calendar.dateInterval(of: .weekOfYear, for: lastDayOfMonth),
              let lastWeekEnd = calendar.date(byAdding: .day, value: -1, to: lastWeekInterval.end) else {
            return (firstWeekStart, lastDayOfMonth)
        }
        
        return (firstWeekStart, lastWeekEnd)
    }
    
    @MainActor
    func createScheduleFromCategory(_ category: TaskCategory) async {
        do {
            let calendar = Calendar.current
            let selectedDate = state.selectedDate
            
            let startTime = calendar.date(bySettingHour: calendar.component(.hour, from: Date()),
                                        minute: calendar.component(.minute, from: Date()),
                                        second: 0,
                                        of: selectedDate) ?? selectedDate
            
            let endTime = calendar.date(byAdding: .hour, value: 1, to: startTime) ?? startTime
            
            let scheduleCategory = mapTaskCategoryToScheduleCategory(category.name)
            
            let createdSchedule = try await calendarUseCase.createSchedule(
                title: category.name,
                date: selectedDate,
                startTime: startTime,
                endTime: endTime,
                category: scheduleCategory,
                temperature: 50,
                allDay: false,
                alarmOption: .none
            )
            
            effectSubject.send(.showSuccess("\(category.name) 일정이 추가되었습니다"))
            
            await loadSchedules()
            
        } catch {
            effectSubject.send(.showError("일정 추가에 실패했습니다: \(error.localizedDescription)"))
        }
    }
    
    func mapTaskCategoryToScheduleCategory(_ categoryName: String) -> ScheduleCategory {
        let companyKeywords = ["출근", "회사", "회의", "업무", "근무", "사무", "직장"]
        let personalKeywords = ["운동", "쇼핑", "선물", "개인", "취미", "여가"]
        
        if companyKeywords.contains(where: { categoryName.contains($0) }) {
            return .company
        } else if personalKeywords.contains(where: { categoryName.contains($0) }) {
            return .personal
        } else {
            return .etc 
        }
    }
    
    func mapCategoryNameToScheduleCategory(_ categoryName: String) -> ScheduleCategory {
        switch categoryName {
        case "회사":
            return .company
        case "개인":
            return .personal
        case "연차":
            return .leave
        case "기타":
            return .etc
        default:
            return .etc
        }
    }
}

// MARK: - Helper Methods
private extension CalendarStore {
    func createTodoFromSchedule(id: Int, schedule: Schedule) -> DesignSystem.TodoItem {
        let category = DesignSystem.TodoCategory(
            name: schedule.category.displayName,
            color: schedule.category.designSystemColor
        )
        
        return DesignSystem.TodoItem(
            id: id,
            title: schedule.title,
            isCompleted: schedule.completed,
            category: category,
            time: schedule.allDay ? "하루 종일" : schedule.startTime.toString(format: "a h:mm"),
            scheduleId: schedule.id
        )
    }
    
    func createTodoFromCategory(id: Int, title: String, category: TaskCategory, time: String? = nil) -> DesignSystem.TodoItem {
        DesignSystem.TodoItem(
            id: id,
            title: title,
            isCompleted: false,
            category: DesignSystem.TodoCategory(name: category.name, color: category.color),
            time: time,
            scheduleId: nil
        )
    }
}

// MARK: - View Helpers
extension CalendarStore {
    @ViewBuilder
    func calendarCellContent(for date: Date) -> some View {
        let schedulesForDate = getSchedulesForDate(date)
        
        if !schedulesForDate.isEmpty {
            let avgTemperature = calculateAverageTemperature(for: schedulesForDate)
            temperatureImage(avgTemperature, schedules: schedulesForDate)
                .resizable()
                .scaledToFit()
        } else {
            DS.Images.imgFlour
                .resizable()
                .scaledToFit()
        }
    }
    
    private func getSchedulesForDate(_ date: Date) -> [Schedule] {
        let dateString = date.toString(format: "yyyy-MM-dd")
        
        if let daySchedule = state.dailySchedules.first(where: { $0.date == dateString }) {
            return daySchedule.schedules
        }
        
        return []
    }
    
    private func calculateAverageTemperature(for schedules: [Schedule]) -> Int {
        guard !schedules.isEmpty else { return 0 }
        
        let totalTemperature = schedules.reduce(0) { $0 + $1.temperature }
        return totalTemperature / schedules.count
    }
    
    private func temperatureImage(_ temperature: Int, schedules: [Schedule]) -> Image {
        if schedules.isEmpty {
            return DS.Images.imgFlour
        }
        
        let hasVacation = schedules.contains { $0.category == .leave }
        if hasVacation {
            return DS.Images.imgToastVacation
        }
        
        let hasCompletedTasks = schedules.contains { $0.completed }
        
        if !hasCompletedTasks {
            return DS.Images.imgToastNone
        }
        
        switch temperature {
        case 0...25:
            return DS.Images.imgToastDefault
        case 26...50:
            return DS.Images.imgToastEven
        case 51...100:
            return DS.Images.imgToastBurn
        default:
            return DS.Images.imgToastDefault
        }
    }
    @MainActor
        func handleTaskCompletionToggled(_ index: Int) async {
            guard index < state.todoItems.count else { return }
            
            let todoItem = state.todoItems[index]
            
            guard let scheduleId = todoItem.scheduleId else {
                state.todoItems[index].isCompleted.toggle()
                return
            }
            
            let previousState = state.todoItems[index].isCompleted
            state.todoItems[index].isCompleted = !previousState
            
            do {
                let updatedSchedule = try await calendarUseCase.updateScheduleState(
                    id: scheduleId,
                    isComplete: !previousState
                )
                
                state.todoItems[index].isCompleted = updatedSchedule.completed
                
                let message = updatedSchedule.completed ? "할일을 완료했습니다" : "할일을 미완료로 변경했습니다"
                effectSubject.send(.showSuccess(message))
                
            } catch {
                state.todoItems[index].isCompleted = previousState
                effectSubject.send(.showError("할일 상태 변경에 실패했습니다: \(error.localizedDescription)"))
            }
        }
}
