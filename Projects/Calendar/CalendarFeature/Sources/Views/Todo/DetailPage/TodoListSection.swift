//
//  TodoListSection.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/13/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DesignSystem
import SwiftUI

struct TodoListSection: View {
    let todoItems: [DesignSystem.TodoItem]
    let incompleteTodoCount: Int
    let onToggle: (Int) -> Void
    let onMoreTapped: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
            
            if todoItems.isEmpty {
                VStack(spacing: 16) {
                    Text("아직 할 일이 없어요.")
                        .font(.body1)
                        .foregroundColor(DS.Colors.Text.disable)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(Array(todoItems.enumerated()), id: \.element.id) { index, todo in
                        TodoCheckboxComponent(
                            todoItem: todo,
                            onToggle: {
                                onToggle(index)
                            },
                            onMoreTapped: { onMoreTapped(index) }
                        )
                        .contentShape(Rectangle())
                    }
                }
            }
        }
    }
}
