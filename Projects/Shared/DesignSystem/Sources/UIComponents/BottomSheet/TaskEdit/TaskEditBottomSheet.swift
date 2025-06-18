//
//  TaskEditBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 할 일 수정 바텀시트
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
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            VStack(spacing: 0) {
                Button(action: {
                    onEditAction()
                    isPresented = false
                }) {
                    HStack(spacing: 8) {
                        Image(.icnEdit)
                        
                        Text(" 할 일 수정")
                            .font(.body1)
                            .foregroundColor(DS.Colors.Text.gray900)
                        
                        Spacer()
                    }
                    .frame(height: 56)
                }
                
                Button(action: {
                    onTomorrowAction()
                    isPresented = false
                }) {
                    HStack(spacing: 8) {
                        Image(.icnArrowForward)
                        
                        Text("내일 또 하기")
                            .font(.body1)
                            .foregroundColor(DS.Colors.Text.gray900)
                        
                        Spacer()
                    }
                    .frame(height: 56)
                }
                
                Button(action: {
                    onDeleteAction()
                    isPresented = false
                }) {
                    HStack(spacing: 8) {
                        Image(.icnDelete)
                        
                        Text("삭제하기")
                            .font(.body1)
                            .foregroundColor(DS.Colors.Text.gray900)
                        
                        Spacer()
                    }
                    .frame(height: 56)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .presentationDetents([.height(192)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}
