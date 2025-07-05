//
//  CalendarView.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import CalendarDomain
import DIContainer

public struct CalendarView: View {
    @Dependency private var calendarUseCase: CalendarUseCaseProtocol
    @State private var events: [CalendarEvent] = []
    @State private var isLoading = false
    @EnvironmentObject var coordinator: CalendarCoordinator
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "calendar")
                .font(.system(size: 60))
                .foregroundColor(.orange)
            
            Text("캘린더")
                .font(.title)
            
            if isLoading {
                ProgressView()
            } else {
                Text("이벤트: \(events.count)개")
                    .foregroundColor(.gray)
            }
            
            // 네비게이션 테스트 버튼들 (간소화)
            VStack(spacing: 12) {
                Button("이벤트 상세") {
                    coordinator.push(.eventDetail("sample-123"))
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("새 이벤트") {
                    coordinator.sheet(.createEvent)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
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
            events = try await calendarUseCase.getCalendarEvents()
        } catch {
            print("캘린더 이벤트 로드 실패: \(error)")
        }
        isLoading = false
    }
}
