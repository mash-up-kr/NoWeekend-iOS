//
//  DateDetailStore.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import DesignSystem
import DIContainer
import SwiftUI
import Utils

@MainActor
@Observable
public class DateDetailStore {
    public var state = DateDetailState()
    
    let selectedDate: Date
    private let calendarUseCase: CalendarUseCaseProtocol?
    
    public init(selectedDate: Date, calendarUseCase: CalendarUseCaseProtocol? = nil) {
        self.selectedDate = selectedDate
        self.calendarUseCase = calendarUseCase
    }
    
    public func send(_ intent: DateDetailIntent) {
        switch intent {
        case .loadSchedules:
            Task { await loadSchedules() }
            
        case .toggleTask(let index):
            // 기존의 로컬 토글을 API 연동으로 변경
            Task { await handleTaskCompletionToggled(index) }
            
        case .taskCompletionToggled(let index):
            Task { await handleTaskCompletionToggled(index) }
            
        case .showTaskEditSheet(let index):
            state.selectedTaskIndex = index
            state.showTaskEditSheet = true
            
        case .hideTaskEditSheet:
            state.showTaskEditSheet = false
            
        case .editTask:
            state.showTaskEditSheet = false
            if let index = state.selectedTaskIndex {
                state.editingTaskIndex = index
            }
            
        case .tomorrowTask:
            state.showTaskEditSheet = false
            
        case .deleteTask:
            state.showTaskEditSheet = false
            if let index = state.selectedTaskIndex {
                Task { await handleTaskDelete(index) }
            }
            
        case .showCategorySelection:
            state.showCategorySelection = true
            
        case .hideCategorySelection:
            state.showCategorySelection = false
            
        case .selectCategory(let category):
            Task {
                await createScheduleFromCategory(category)
            }
            state.showCategorySelection = false
            
        case .navigateToTaskCreate:
            state.showCategorySelection = false
        }
    }
}

// MARK: - Private Methods
private extension DateDetailStore {
    func loadSchedules() async {
        let useCase = calendarUseCase ?? DIContainer.shared.resolve(CalendarUseCaseProtocol.self)
        
        state.isLoading = true
        state.errorMessage = nil
        
        do {
            let schedules = try await useCase.getSchedulesForDateRange(
                startDate: selectedDate,
                endDate: selectedDate
            )
            
            if let daySchedule = schedules.first {
                let todoItems = daySchedule.schedules.enumerated().map { index, schedule in
                    createTodoFromSchedule(id: index + 1, schedule: schedule)
                }
                state.todoItems = todoItems
                state.schedules = daySchedule.schedules
            } else {
                state.todoItems = []
                state.schedules = []
            }
            
        } catch {
            state.errorMessage = "일정 로딩에 실패했습니다: \(error.localizedDescription)"
        }
        
        state.isLoading = false
    }
    
    func createScheduleFromCategory(_ category: TaskCategory) async {
        let useCase = calendarUseCase ?? DIContainer.shared.resolve(CalendarUseCaseProtocol.self)
        
        do {
            let calendar = Calendar.current
            
            let startTime = calendar.date(bySettingHour: calendar.component(.hour, from: Date()),
                                        minute: calendar.component(.minute, from: Date()),
                                        second: 0,
                                        of: selectedDate) ?? selectedDate
            
            let endTime = calendar.date(byAdding: .hour, value: 1, to: startTime) ?? startTime
            
            let scheduleCategory = mapTaskCategoryToScheduleCategory(category.name)
            
            let createdSchedule = try await useCase.createSchedule(
                title: category.name,
                date: selectedDate,
                startTime: startTime,
                endTime: endTime,
                category: scheduleCategory,
                temperature: 50,
                allDay: false,
                alarmOption: .none
            )
            
            print("✅ 일정 생성 성공: \(category.name)")
            
            await loadSchedules()
            
        } catch {
            print("❌ 일정 생성 실패: \(error.localizedDescription)")
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
            let updatedSchedule = try await calendarUseCase?.updateScheduleState(
                id: scheduleId,
                isComplete: !previousState
            )
            
            state.todoItems[index].isCompleted = ((updatedSchedule?.completed) != nil)
            
        
            await loadSchedules()
            
        } catch {
            state.todoItems[index].isCompleted = previousState
        }
    }

    @MainActor
      func handleTaskDelete(_ index: Int) async {
          guard index < state.todoItems.count else { return }
          
          let todoItem = state.todoItems[index]
          
          guard let scheduleId = todoItem.scheduleId else {
              state.todoItems.remove(at: index)
              state.selectedTaskIndex = nil
              return
          }
          
          do {
              let useCase = calendarUseCase ?? DIContainer.shared.resolve(CalendarUseCaseProtocol.self)
              try await useCase.deleteSchedule(id: scheduleId)
              
              state.todoItems.remove(at: index)
              state.selectedTaskIndex = nil
              
              await loadSchedules()
              
          } catch {
              state.errorMessage = "일정 삭제에 실패했습니다: \(error.localizedDescription)"
          }
      }
}
