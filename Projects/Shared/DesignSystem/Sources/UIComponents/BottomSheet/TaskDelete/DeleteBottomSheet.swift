//
//  DeleteBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

public struct DeleteBottomSheet: View {
    public let message: String
    public let onDeleteAction: () -> Void
    @Binding public var isPresented: Bool
    
    public init(
        message: String,
        onDeleteAction: @escaping () -> Void,
        isPresented: Binding<Bool>
    ) {
        self.message = message
        self.onDeleteAction = onDeleteAction
        self._isPresented = isPresented
    }
    
    public var body: some View {
        BottomSheetContainer(height: 136) {
            ActionList(
                items: [
                    ActionItem(
                        image: Image(.icnEdit),
                        title: "할일 수정",
                        action: {
                            isPresented = false
                        }
                    ),
                    ActionItem(
                        image: Image(.icnDelete),
                        title: "삭제",
                        action: onDeleteAction
                    )
                ],
                isPresented: $isPresented
            )
        }
    }
}
