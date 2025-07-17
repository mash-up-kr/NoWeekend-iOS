//
//  DateDetailView.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import DesignSystem
import SwiftUI

public struct DateDetailView: View {
    @EnvironmentObject private var coordinator: CalendarCoordinator
    @State private var store: DateDetailStore
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter
    }()
    
    private let defaultCategories: [TaskCategory] = [
        TaskCategory(name: "출근하기", color: DS.Colors.TaskItem.green),
        TaskCategory(name: "운동하기", color: DS.Colors.TaskItem.orange),
        TaskCategory(name: "선물사기", color: DS.Colors.Neutral.gray700)
    ]
    
    public init(selectedDate: Date, calendarUseCase: CalendarUseCaseProtocol? = nil) {
        self._store = State(initialValue: DateDetailStore(selectedDate: selectedDate, calendarUseCase: calendarUseCase))
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navigationBar
                
                if store.state.isLoading {
                    loadingView
                } else if let errorMessage = store.state.errorMessage {
                    errorView(errorMessage)
                } else {
                    contentView
                }
            }
            .background(DS.Colors.Background.normal)
            
            overlayContent
            floatingButton
        }
        .navigationBarHidden(true)
        .sheet(isPresented: taskEditSheetBinding) {
            TaskEditBottomSheet(
                onEditAction: { store.send(.editTask) },
                onTomorrowAction: { store.send(.tomorrowTask) },
                onDeleteAction: { store.send(.deleteTask) },
                isPresented: taskEditSheetBinding
            )
        }
        .task {
            store.send(.loadSchedules)
        }
    }
}

// MARK: - View Components
private extension DateDetailView {
    var navigationBar: some View {
        CustomNavigationBar(
            type: .backWithLabel(dateFormatter.string(from: store.selectedDate)),
            onBackTapped: {
                coordinator.pop()
            }
        )
    }
    
    var loadingView: some View {
        VStack {
            ProgressView("일정을 불러오는 중...")
                .padding()
            Spacer()
        }
    }
    
    func errorView(_ message: String) -> some View {
        VStack {
            Text("오류: \(message)")
                .foregroundColor(.red)
                .padding()
            Spacer()
        }
    }
    
    var contentView: some View {
        ScrollView {
            VStack(spacing: 0) {
                TemperatureCard(temperature: store.state.averageTemperature)
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                
                TemperatureProgressBar(temperature: store.state.averageTemperature)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                
                TodoListSection(
                    todoItems: store.state.todoItems,
                    incompleteTodoCount: store.state.incompleteTodoCount,
                    onToggle: { index in
                        // 올바른 API 연동 Intent 호출
                        store.send(.taskCompletionToggled(index))
                    },
                    onMoreTapped: { index in store.send(.showTaskEditSheet(index: index)) }
                )
                .padding(.top, 24)
                
                Spacer(minLength: 100)
            }
        }
    }
    @ViewBuilder
    var overlayContent: some View {
        if store.state.showCategorySelection {
            TaskCategorySelectionView(
                isPresented: categorySelectionBinding,
                categories: defaultCategories,
                onCategorySelected: { category in store.send(.selectCategory(category)) },
                onDirectInputTapped: {
                    store.send(.navigateToTaskCreate)
                    coordinator.push(.taskCreate(selectedDate: store.selectedDate))
                }
            )
            .zIndex(1)
        }
    }
    
    var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingAddButton(
                    isExpanded: true,
                    isShowingCategory: store.state.showCategorySelection,
                    action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            store.send(.showCategorySelection)
                        }
                    },
                    dismissAction: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            store.send(.hideCategorySelection)
                        }
                    }
                )
                .padding(.trailing, 20)
                .padding(.bottom, 33)
            }
        }
        .zIndex(4)
    }
}

// MARK: - Binding Helpers
private extension DateDetailView {
    var taskEditSheetBinding: Binding<Bool> {
        Binding(
            get: { store.state.showTaskEditSheet },
            set: { _ in store.send(.hideTaskEditSheet) }
        )
    }
    
    var categorySelectionBinding: Binding<Bool> {
        Binding(
            get: { store.state.showCategorySelection },
            set: { _ in store.send(.hideCategorySelection) }
        )
    }
}

#Preview {
    NavigationStack {
        DateDetailView(selectedDate: Date())
            .environmentObject(CalendarCoordinator())
    }
}
