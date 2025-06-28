//
//  TodoScrollSection.swift
//  Feature
//
//  Created by 이지훈 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct TodoScrollSection: View {
    @Binding var todoItems: [TodoItem]
    @Binding var selectedTaskIndex: Int?
    @Binding var showTaskEditSheet: Bool
    @Binding var scrollOffset: CGFloat
    @Binding var isScrolling: Bool
    
    private var incompleteTodoCount: Int {
        todoItems.filter { !$0.isCompleted }.count
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                todoSection
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .preference(key: ScrollOffsetPreferenceKey.self,
                                          value: geometry.frame(in: .named("scroll")).minY)
                        }
                    )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                withAnimation(.easeInOut(duration: 0.1)) {
                    scrollOffset = -value
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        isScrolling = true
                    }
                    .onEnded { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isScrolling = false
                        }
                    }
            )
        }
    }
    
    private var todoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 할일 헤더
            HStack {
                HStack(spacing: 0) {
                    Text("할 일 ")
                        .font(.heading5)
                        .foregroundStyle(DS.Colors.Text.netural)
                    
                    Text("\(incompleteTodoCount)")
                        .font(.heading5)
                        .foregroundStyle(DS.Colors.Text.netural)
                    
                    Text(" / ")
                        .font(.heading5)
                        .foregroundStyle(DS.Colors.Text.disable)
                    
                    Text("\(todoItems.count)")
                        .font(.heading5)
                        .foregroundStyle(DS.Colors.Text.disable)
                    
                    Text("개")
                        .font(.heading5)
                        .foregroundStyle(DS.Colors.Text.netural)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
            LazyVStack(spacing: 0) {
                ForEach(Array(todoItems.enumerated()), id: \.element.id) { index, todo in
                    TodoCheckboxComponent(
                        isCompleted: todo.isCompleted,
                        title: todo.title,
                        category: todo.category,
                        time: todo.time,
                        onToggle: {
                            todoItems[index].isCompleted.toggle()
                        }
                    )
                    .contentShape(Rectangle())
                    .onLongPressGesture {
                        selectedTaskIndex = index
                        showTaskEditSheet = true
                    }
                }
            }
        }
    }
}
