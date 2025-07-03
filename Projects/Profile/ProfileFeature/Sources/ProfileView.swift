//
//  ProfileView.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import ProfileDomain
import DesignSystem
import Utils

public struct ProfileView: View {
    @StateObject private var viewModel = MockProfileViewModel()
    
    public init() {
        print("👤 ProfileView 초기화 (Mock 데이터 사용)")
    }
    
    public var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.blue)
            
            if let user = viewModel.user {
                Text(user.name)
                    .font(.title)
                
                Text(user.email)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            } else {
                Text("시종")
                    .font(.title)
                    .padding()
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadProfile()
        }
    }
}

// 임시 Mock ViewModel
class MockProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading: Bool = false
    
    @MainActor
    func loadProfile() async {
        isLoading = true
        
        // 임시 Mock 데이터
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        user = User(id: "mock", name: "나희", email: "nahee@noweekend.com")
        
        isLoading = false
        print("👤 Mock 프로필 로드 완료")
    }
}
