//
//  LoginView.swift
//  Calendar
//
//  Created by SiJongKim on 6/27/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

struct LoginView: View {
    var body: some View {
        VStack {
            Spacer()
            DS.Images.imageMain
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
