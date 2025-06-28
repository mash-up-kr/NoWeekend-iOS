//
//  TaskEditBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct TaskEditBottomSheet: View {
    public let onEditAction: () -> Void
    public let onTomorrowAction: () -> Void
    public let onDeleteAction: () -> Void
    @Binding public var isPresented: Bool
    
    public init(
        onEditAction: @escaping () -> Void,
        onTomorrowAction: @escaping () -> Void,
        onDeleteAction: @escaping () -> Void,
        isPresented: Binding<Bool>
    ) {
        self.onEditAction = onEditAction
        self.onTomorrowAction = onTomorrowAction
        self.onDeleteAction = onDeleteAction
        self._isPresented = isPresented
    }
    
    public var body: some View {
        BottomSheetContainer(height: 192) {
            ActionList(
                items: [
                    ActionItem(
                        image: Image(.icnEdit),
                        title: " 할 일 수정",
                        textColor: DS.Colors.Text.netural,
                        action: onEditAction
                    ),
                    ActionItem(
                        image: Image(.icnArrowForward),
                        title: "내일 또 하기",
                        textColor: DS.Colors.Text.netural,
                        action: onTomorrowAction
                    ),
                    ActionItem(
                        image: Image(.icnDelete),
                        title: "삭제하기",
                        textColor: DS.Colors.Text.netural,
                        action: onDeleteAction
                    )
                ],
                isPresented: $isPresented
            )
        }
    }
}
