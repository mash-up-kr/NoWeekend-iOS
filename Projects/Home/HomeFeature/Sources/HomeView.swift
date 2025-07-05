//
//  HomeView.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import HomeDomain
import Core

public struct HomeView: View {
    @Dependency private var eventUseCase: EventUseCaseProtocol
    @State private var events: [Event] = []
    @State private var isLoading = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("홈")
                .font(.title)
            
            if isLoading {
                ProgressView()
            } else {
                Text("이벤트: \(events.count)개")
                    .foregroundColor(.gray)
            }
        }
        .navigationBarHidden(true)
        .task {
            await loadEvents()
        }
    }
    
    private func loadEvents() async {
        isLoading = true
        do {
            events = try await eventUseCase.getEvents()
        } catch {
            print("이벤트 로드 실패: \(error)")
        }
        isLoading = false
    }
}
