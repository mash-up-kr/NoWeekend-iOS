//
//  TodoCheckboxComponent.swift
//  Shared
//
//  Created by 이지훈 on 6/22/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

struct TodoCategory {
    let name: String
    let color: Color
}

struct TodoCheckboxComponent: View {
    let isCompleted: Bool
    let title: String
    let category: TodoCategory?
    let time: String?
    let date: String?
    let onToggle: () -> Void
    
    init(
        isCompleted: Bool,
        title: String,
        category: TodoCategory? = TodoCategory(name: "개인", color: DS.Colors.TaskItem.orange),
        time: String? = nil,
        onToggle: @escaping () -> Void
    ) {
        self.isCompleted = isCompleted
        self.title = title
        self.category = category
        self.time = time
        self.date = nil
        self.onToggle = onToggle
    }
    
    private var timeOrDate: String {
        if let time = time {
            return time
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M월 d일"
            return formatter.string(from: Date())
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                         (isCompleted ? DS.Images.icnCheckbox : DS.Images.icTodo)
                             .resizable()
                             .frame(width: 18, height: 18)
                     }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body2)
                    .foregroundColor(DS.Colors.Neutral._900)
                    .lineLimit(1)
                if category != nil {
                    HStack(spacing: 8) {
                        if let category = category {
                            Text(category.name)
                                .font(.subtitle1)
                                .foregroundColor(category.color)
                        }
                        
                        if category != nil {
                            Rectangle()
                                .fill(DS.Colors.Border.gray300)
                                .frame(width: 2, height: 12)
                        }
                        
                        Text(timeOrDate)
                            .font(.body2)
                            .foregroundColor(DS.Colors.Text.gray800)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 24)
        .opacity(isCompleted ? 0.32 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isCompleted)
    }
}

struct TodoCheckboxComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            TodoCheckboxComponent(
                isCompleted: false,
                title: "기본 개인 할일",
                onToggle: { }
            )
            
            TodoCheckboxComponent(
                isCompleted: false,
                title: "시간이 있는 할일ㅏㅏㅗㅓㅏㅗㅓㅏㅗㅓㅏㅘㅓㅗㅓㅏㅗㅓㅏㅗㅓㅏㅗㅓㅏㅗㅓㅏㅗㅓㅏㅗㅓㅏㅗㅓㅏㅗㅓㅏ",
                time: "오전 10:00",
                onToggle: { }
            )
            
            TodoCheckboxComponent(
                isCompleted: false,
                title: "시간 없는 할일",
                onToggle: { }
            )
            
            TodoCheckboxComponent(
                isCompleted: false,
                title: "회사 업무",
                category: TodoCategory(name: "회사", color: DS.Colors.TaskItem.purple),
                time: "오후 2:00",
                onToggle: { }
            )
            
            TodoCheckboxComponent(
                isCompleted: true,
                title: "완료된 할일",
                time: "오전 9:00",
                onToggle: { }
            )
        }
       }
}
