//
//  LoginView.swift
//  Calendar
//
//  Created by 김시종 on 6/17/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

public struct LoginView: View {
    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
            DS.Images.mockLogin
            Spacer()
            
            VStack(spacing: 12) {
                NWButton(variant: .outline, size: .xl) {
                    // 애플 로그인 액션
                } content: {
                    HStack {
                        DS.Images.icon
                        Text("Apple 계정으로 시작")
                    }
                }

                NWButton(variant: .outline, size: .xl) {
                    // 구글 로그인 액션
                } content: {
                    HStack {
                        DS.Images.icon1
                        Text("Google 계정으로 시작")
                    }
                }

            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
