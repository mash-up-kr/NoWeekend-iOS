//
//  HomeView.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import HomeDomain
import DesignSystem
import Utils

public struct HomeView: View {
    @StateObject private var viewModel = MockHomeViewModel()
    
    public init() {
        print("🏠 HomeView 초기화 (Mock 데이터 사용)")
    }
    
    public var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)
            
            Text("나희")
                .font(.title)
                .padding()
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Text("이벤트 수: \(viewModel.events.count)")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadEvents()
        }
    }
}

// 임시 Mock ViewModel
class MockHomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    
    @MainActor
    func loadEvents() async {
        isLoading = true
        
        // 임시 Mock 데이터
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        events = [
            Event(id: "1", title: "Mock 이벤트 1", date: Date()),
            Event(id: "2", title: "Mock 이벤트 2", date: Date()),
            Event(id: "3", title: "Mock 이벤트 3", date: Date())
        ]
        
        isLoading = false
        print("🏠 Mock 이벤트 로드 완료: \(events.count)개")
    }
}
