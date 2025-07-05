//
//  ProfileView.swift
//  ProfileFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import ProfileDomain
import Coordinator
import DIContainer

public struct ProfileView: View {
    @Dependency private var userUseCase: UserUseCaseProtocol
    @State private var user: User?
    @State private var isLoading = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            if let user = user {
                Text(user.name)
                    .font(.title)
                Text(user.email)
                    .foregroundColor(.gray)
            } else if isLoading {
                ProgressView()
            } else {
                Text("프로필")
                    .font(.title)
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadProfile()
        }
    }
    
    private func loadProfile() async {
        isLoading = true
        do {
            user = try await userUseCase.getCurrentUser()
        } catch {
            print("프로필 로드 실패: \(error)")
        }
        isLoading = false
    }
}
