import SwiftUI
import CalendarInterface
import Domain
import DesignSystem

public struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var selectedToggle: CalendarNavigationBar.ToggleOption = .week
    @State private var showDatePicker = false
    @State private var showTaskEditSheet = false
    @State private var selectedTaskIndex: Int?
    @State private var scrollOffset: CGFloat = 0
    @State private var isScrolling = false
    
    @State private var todoItems = [
        TodoItem(id: 1, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 2, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 3, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 4, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00"),
        TodoItem(id: 5, title: "할 일 제목이 들어갑니다.", isCompleted: false, category: DesignSystem.TodoCategory(name: "회사", color: DS.Colors.TaskItem.orange), time: "오전 10:00")
    ]
    
    // 플로팅 버튼 상태 계산
    private var isFloatingButtonExpanded: Bool {
        scrollOffset < 50 && !isScrolling
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
                
                // 기존 CalendarSection 사용 (주/월 토글 기능 포함)
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
                    .background(DS.Colors.Background.white)
                } else {
                    Spacer()
                        .background(DS.Colors.Background.white)
                }
            }
            .background(DS.Colors.Background.white)
            
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
            TaskEditSheetView(
                todoItems: $todoItems,
                selectedTaskIndex: $selectedTaskIndex,
                showTaskEditSheet: $showTaskEditSheet
            )
        }
    }
    
    @ViewBuilder
    private func calendarCellContent(for date: Date) -> some View {
        let todosForDate = getTodosForDate(date)
        
        if !todosForDate.isEmpty {
            DS.Images.imgToastDefault
                .resizable()
                .scaledToFit()
        } else {
            DS.Images.imgFlour
                .resizable()
                .scaledToFit()
        }
    }
    
    private func formatSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
    
    private func getTodosForDate(_ date: Date) -> [TodoItem] {
        return todoItems.prefix(2).map { $0 }
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
