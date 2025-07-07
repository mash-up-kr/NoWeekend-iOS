//
//  LoginView.swift
//  Calendar
//
//  Created by SiJongKim on 6/27/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import DesignSystem

public struct LoginView: View {
    @ObservedObject private var store: LoginStore
    
    public init(store: LoginStore) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Spacer()
            DS.Images.imageMain
            Spacer()
            
            VStack(spacing: 12) {
                NWButton(variant: .outline, size: .xl) {
                    store.send(.signInWithApple)
                } content: {
                    HStack {
                        DS.Images.icon
                        Text("Apple 계정으로 시작")
                    }
                }
                
                NWButton(variant: .outline, size: .xl) {
                    store.send(.signInWithGoogle)
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

