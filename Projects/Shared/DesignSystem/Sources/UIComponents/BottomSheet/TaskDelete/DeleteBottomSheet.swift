//
//  DeleteBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 삭제 확인 바텀시트
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
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            VStack(spacing: 0) {
                // 할일 수정
                Button(action: {
                    isPresented = false
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "pencil") // TODO: 아이콘 수정
                        
                        Text("할일 수정")
                            .font(.body)
                            .foregroundColor(.primary) // TODO: 색상수정
                        
                        Spacer()
                    }
                    .frame(height: 56)
                }
                
                // 삭제
                Button(action: {
                    onDeleteAction()
                    isPresented = false
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "trash") // TODO: 아이콘 수정
                        
                        Text("삭제")
                            .font(.body)
                            .foregroundColor(.primary) // TODO: 색상수정
                        
                        Spacer()
                    }
                    .frame(height: 56)
                }
            }
            .padding(.horizontal, 20)
            Spacer()
        }
        .presentationDetents([.height(136)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}
