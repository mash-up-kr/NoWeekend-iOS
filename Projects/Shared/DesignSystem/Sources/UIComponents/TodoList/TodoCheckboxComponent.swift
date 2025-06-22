//
//  TodoCheckboxComponent.swift
//  Shared
//
//  Created by 이지훈 on 6/22/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

struct TodoCheckboxComponent: View {
    let isCompleted: Bool
    let title: String
    let category: String?
    let categoryColor: Color?
    let time: String?
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                if isCompleted {
                    DS.Images.icnCheckbox
                        .resizable()
                        .frame(width: 18, height: 18)
                } else {
                    DS.Images.icTodo
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isCompleted)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body2)
                    .foregroundColor(DS.Colors.Neutral._900)
                    .animation(.easeInOut(duration: 0.2), value: isCompleted)
                
                if let category = category, let time = time {
                    HStack(spacing: 8) {
                        Text(category)
                            .font(.subtitle1)
                            .foregroundColor(categoryColor ?? DS.Colors.TaskItem.etc)
                        
                        Rectangle()
                            .fill(DS.Colors.Border.gray300)
                            .frame(width: 2, height: 12)
                        
                        Text(time)
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
                title: "할 일 제목이 들어갑니다.",
                category: "회사",
                categoryColor: DS.Colors.TaskItem.purple,
                time: "오전 10:00",
                onToggle: { }
            )
            
            TodoCheckboxComponent(
                isCompleted: true,
                title: "완료된 할 일입니다.",
                category: "개인",
                categoryColor: DS.Colors.TaskItem.orange,
                time: "오후 2:00",
                onToggle: { }
            )
            
            TodoCheckboxComponent(
                isCompleted: false,
                title: "간단한 할 일",
                category: nil,
                categoryColor: nil,
                time: nil,
                onToggle: { }
            )
        }
    }
}
