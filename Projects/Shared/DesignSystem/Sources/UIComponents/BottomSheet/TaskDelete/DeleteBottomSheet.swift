//
//  DeleteBottomSheet.swift
//  Shared
//
//  Created by 이지훈 on 6/18/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI

/// 삭제 확인 바텀시트
struct DeleteBottomSheet: View {
    let message: String
    let onDeleteAction: () -> Void
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            CustomDragIndicator()
            
            VStack(spacing: 0) {
                // 할일 수정
                Button(action: {
                    isPresented = false
                }) {
                    HStack(spacing: 8) {
                        Image(.icnEdit)
                        
                        Text("할일 수정")
                            .font(.body1)
                            .foregroundColor(DS.Colors.Text.gray900)
                        
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
                        Image(.icnDelete)
                        
                        Text("삭제")
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
        .presentationDetents([.height(136)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(16)
    }
}
