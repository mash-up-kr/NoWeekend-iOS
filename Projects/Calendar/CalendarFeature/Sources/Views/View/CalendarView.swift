//
//  CalendarView.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import DesignSystem
import Utils
import DIContainer
import SwiftUI
import Utils

public struct CalendarView: View {
    @Dependency private var calendarUseCase: CalendarUseCaseProtocol

    @State private var selectedDate = Date()
    @State private var selectedToggle: CalendarNavigationBar.ToggleOption = .week
    @State private var showDatePicker = false
    @State private var showTaskEditSheet = false
    @State private var selectedTaskIndex: Int?
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolling = false
    
    @State private var dailySchedules: [DailySchedule] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @State private var todoItems = [
        TodoItem(id: 1, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 2, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 3, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 4, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 5, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00")
    ]
    
    private var isFloatingButtonExpanded: Bool {
        scrollOffset == 0 && !isScrolling
    }
    
    public init() {}
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CalendarNavigationBar(
                    dateText: formatSelectedDate(selectedDate),
                    onDateTapped: {
                        showDatePicker = true
                    },
                    onToggleChanged: { toggle in
                        selectedToggle = toggle
                    }
                )
                
                CalendarSection(
                    selectedDate: selectedDate,
                    selectedToggle: selectedToggle,
                    onDateTap: { date in
                        selectedDate = date
                    },
                    calendarCellContent: calendarCellContent
                )
                
                if selectedToggle == .week {
                    TodoScrollSection(
                        todoItems: $todoItems,
                        selectedTaskIndex: $selectedTaskIndex,
                        showTaskEditSheet: $showTaskEditSheet,
                        scrollOffset: $scrollOffset,
                        isScrolling: $isScrolling
                    )
                    .background(.white)
                } else {
                    Spacer()
                        .background(.white)
                }
            }
            .background(.white)
            
            // 플로팅 버튼
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingAddButton(
                        isExpanded: isFloatingButtonExpanded,
                        action: addNewTodo
                    )
                    .padding(.trailing, 20)
                    .padding(.bottom, 33)
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerWithLabelBottomSheet(selectedDate: $selectedDate)
        }
        .sheet(isPresented: $showTaskEditSheet) {
            TaskEditBottomSheet(
                onEditAction: {
                    showTaskEditSheet = false
                },
                onTomorrowAction: {
                    showTaskEditSheet = false
                },
                onDeleteAction: {
                    if let index = selectedTaskIndex {
                        todoItems.remove(at: index)
                    }
                    selectedTaskIndex = nil
                    showTaskEditSheet = false
                },
                isPresented: $showTaskEditSheet
            )
        }
        .onAppear {
            scrollOffset = 0
        }
    }

    private func loadSchedules() async {
            isLoading = true
            errorMessage = nil
            
            do {
                switch selectedToggle {
                case .week:
                    dailySchedules = try await calendarUseCase.getWeeklySchedules(for: selectedDate)
                case .month:
                    dailySchedules = try await calendarUseCase.getMonthlySchedules(for: selectedDate)
                }
            } catch {
                errorMessage = "일정을 불러오는데 실패했습니다: \(error.localizedDescription)"
                print("일정 로드 실패: \(error)")
            }
            
            isLoading = false
        }
        
        @ViewBuilder
        private func calendarCellContent(for date: Date) -> some View {
            let schedulesForDate = getSchedulesForDate(date)
            
            if !schedulesForDate.isEmpty {
                DS.Images.imgToastDefault
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
            return dailySchedules
                .first { $0.date == dateString }?
                .schedules ?? []
        }
    
    private func formatSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
    
    private func getTodosForDate(_ date: Date) -> [TodoItem] {
        todoItems.prefix(2).map { $0 }
    }
    
  private func addNewTodo() {
        let newTodo = TodoItem(
            id: todoItems.count + 1,
            title: "새로운 할 일",
            isCompleted: false,
            category: DesignSystem.TodoCategory(name: "개인", color: DS.Colors.TaskItem.green),
            time: nil
        )
        todoItems.append(newTodo)
    }
}

#Preview {
    CalendarView()
}
