//
//  CalendarView.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import Combine
import DesignSystem
import DIContainer
import SwiftUI
import Utils

public struct CalendarView: View {
    @EnvironmentObject private var coordinator: CalendarCoordinator
    @StateObject private var store = CalendarStore()
    
    @State private var showDatePickerSheet = false
    @State private var showTaskEditSheet = false
    @State private var datePickerSelectedDate = Date()
    
    private let initialDate: Date?
    public init(initialDate: Date? = nil) {
        self.initialDate = initialDate
    }
    
    public var body: some View {
        ZStack {
            mainContent
            overlayContent
            floatingButton
        }
        .sheet(isPresented: $showDatePickerSheet) {
            DatePickerWithLabelBottomSheet(selectedDate: $datePickerSelectedDate)
                .onAppear {
                    datePickerSelectedDate = store.state.selectedDate
                }
                .onDisappear {
                    if datePickerSelectedDate != store.state.selectedDate {
                        store.send(.dateSelected(datePickerSelectedDate))
                    }
                }
        }
        .sheet(isPresented: $showTaskEditSheet) {
            TaskEditBottomSheet(
                onEditAction: {
                    if let index = store.state.selectedTaskIndex {
                        store.send(.taskEditRequested(index))
                    }
                    showTaskEditSheet = false
                },
                onTomorrowAction: {
                    if let index = store.state.selectedTaskIndex {
                        store.send(.taskTomorrowRequested(index))
                    }
                    showTaskEditSheet = false
                },
                onDeleteAction: {
                    if let index = store.state.selectedTaskIndex {
                        store.send(.taskDeleteRequested(index))
                    }
                    showTaskEditSheet = false
                },
                isVacationTask: isSelectedTaskVacation(),
                isPresented: $showTaskEditSheet
            )
            .onAppear {
            }
            .onDisappear {
                Task { @MainActor in
                    store.updateState { state in
                        state.showTaskEditSheet = false
                        state.selectedTaskIndex = nil
                    }
                }
            }
        }
        .onAppear {
            // 수정된 부분: 초기 날짜가 있으면 해당 날짜로 설정
            if let initialDate = initialDate {
                store.send(.dateSelected(initialDate))
            }
            store.send(.viewDidAppear)
        }
        .onReceive(store.effect) { effect in
            handleEffect(effect)
        }
        .task {
            store.send(.viewDidAppear)
        }
    }
}

// MARK: - View Components
private extension CalendarView {
    var mainContent: some View {
        VStack(spacing: 0) {
            CalendarNavigationBar(
                dateText: store.state.currentDateString,
                onDateTapped: {
                    showDatePickerSheet = true
                },
                onToggleChanged: { toggle in
                    store.send(.toggleChanged(toggle))
                }
            )
            
            CalendarSection(
                selectedDate: store.state.selectedDate,
                selectedToggle: store.state.selectedToggle,
                onDateTap: { date in
                    store.send(.dateSelected(date))
                },
                calendarCellContent: store.calendarCellContent
            )
            
            contentSection
            Spacer()
        }
        .background(.white)
    }
    
    @ViewBuilder
    var contentSection: some View {
        if store.state.selectedToggle == .week {
            if store.state.isLoading {
                VStack {
                    ProgressView("일정을 불러오는 중...")
                        .padding()
                    Spacer()
                }
                .background(.white)
            } else {
                ScrollView {
                    TodoListSection(
                        todoItems: store.state.todoItems,
                        incompleteTodoCount: store.state.todoItems.filter { !$0.isCompleted }.count,
                        onToggle: { index in
                            store.send(.taskCompletionToggled(index))
                        },
                        onMoreTapped: { index in
                            store.send(.taskMoreTapped(index))
                        }
                    )
                    .padding(.top, 24)
                    
                    Spacer(minLength: 100)
                }
                .background(.white)
            }
        }
    }
    
    @ViewBuilder
    var overlayContent: some View {
        if store.state.showCategorySelection {
            TaskCategorySelectionView(
                isPresented: Binding(
                    get: { store.state.showCategorySelection },
                    set: { _ in store.send(.categorySelectionToggled) }
                ),
                categories: store.state.recommendedCategories.isEmpty ? getDefaultCategories() : store.state.recommendedCategories,
                onCategorySelected: { category in
                    store.send(.categorySelected(category))
                },
                onDirectInputTapped: {
                    store.send(.directInputTapped)
                }
            )
            .zIndex(1)
        }
    }
    
    private func getDefaultCategories() -> [TaskCategory] {
        return [
            TaskCategory(name: "출근하기", color: DS.Colors.TaskItem.green),
            TaskCategory(name: "운동하기", color: DS.Colors.TaskItem.orange),
            TaskCategory(name: "선물사기", color: DS.Colors.Neutral.gray700)
        ]
    }
    
    var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingAddButton(
                    isExpanded: store.state.isFloatingButtonExpanded,
                    isShowingCategory: store.state.showCategorySelection,
                    action: {
                        store.send(.categorySelectionToggled)
                    },
                    dismissAction: {
                        store.send(.categorySelectionToggled)
                    }
                )
                .padding(.trailing, 20)
                .padding(.bottom, 33)
            }
        }
        .zIndex(4)
    }
}

// MARK: - Helper Methods
private extension CalendarView {
    func isSelectedTaskVacation() -> Bool {
        guard let selectedIndex = store.state.selectedTaskIndex,
              selectedIndex < store.state.todoItems.count else {
            return false
        }
        
        return store.state.todoItems[selectedIndex].category?.name == "연차"
    }
}

// MARK: - Effect Handling
private extension CalendarView {
    func handleEffect(_ effect: CalendarEffect) {
        switch effect {
        case .navigateToTaskCreate(let selectedDate):
            coordinator.push(.taskCreate(selectedDate: selectedDate))
            
        case .navigateToTaskEdit(let todoId, let title, let category, let scheduleId, let selectedDate):
            coordinator.push(.taskEdit(
                todoId: todoId,
                title: title,
                category: category,
                scheduleId: scheduleId,
                selectedDate: selectedDate
            ))
            
        case .navigateToDateDetail(let selectedDate):
            coordinator.push(.dateDetail(selectedDate: selectedDate))
            
        case .showError(let message):
            print("❌ Error: \(message)")
            
        case .showSuccess(let message):
            print("✅ Success: \(message)")
        }
    }
}

extension ScrollView {
    func scrollTrackingModifier(onScrollChanged: @escaping (CGFloat, Bool) -> Void) -> some View {
        self.background(
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scroll")).minY
                )
            }
        )
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            onScrollChanged(value, abs(value) > 1)
        }
        .coordinateSpace(name: "scroll")
    }
}
