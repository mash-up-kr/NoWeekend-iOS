//
//  TaskEditSheetView.swift
//  Feature
//
//  Created by 이지훈 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import DesignSystem
import SwiftUI

struct TaskEditSheetView: View {
    @Binding var todoItems: [TodoItem]
    @Binding var selectedTaskIndex: Int?
    @Binding var showTaskEditSheet: Bool
    
    var body: some View {
        if let index = selectedTaskIndex {
            
            // TODO: 라우터 이후 바텀시트 올리기
            TaskEditBottomSheet(
                onEditAction: {
                    print("할일 수정: \(todoItems[index].title)")
                },
                onTomorrowAction: {
                    print("내일 또 하기: \(todoItems[index].title)")
                },
                onDeleteAction: {
                    todoItems.remove(at: index)
                    selectedTaskIndex = nil
                },
                isPresented: $showTaskEditSheet
            )
        }
    }
}
