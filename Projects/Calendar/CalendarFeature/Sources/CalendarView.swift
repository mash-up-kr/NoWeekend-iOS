//
//  CalendarView.swift
//  CalendarFeature
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import SwiftUI
import HomeDomain
import DesignSystem
import Utils

public struct CalendarView: View {
    @State private var viewModel: CalendarViewModel
    @EnvironmentObject var coordinator: CalendarCoordinator
    
    public init(eventUseCase: EventUseCaseProtocol? = nil) {
        self._viewModel = State(wrappedValue: CalendarViewModel(eventUseCase: eventUseCase))
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // 기존 콘텐츠
            LottieView(type: JSONFiles.Fire.self)
                .frame(width: 100, height: 100)
            
            Text("📅 캘린더")
                .font(.heading2)
                .foregroundColor(DS.Colors.Text.gray900)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Text("이벤트 수: \(viewModel.events.count)")
                    .font(.body1)
                    .foregroundColor(DS.Colors.Text.gray700)
                    .padding()
            }
            
            // 네비게이션 버튼들
            VStack(spacing: 16) {
                // Push 네비게이션 (한 뎁스 더 들어가기)
                Button("이벤트 상세 보기") {
                    coordinator.push(.eventDetail("sample-event-123"))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                // Modal (Sheet) 띄우기
                HStack(spacing: 12) {
                    Button("새 이벤트") {
                        coordinator.sheet(.createEvent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("필터") {
                        coordinator.sheet(.eventFilter)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // FullScreen Cover
                Button("이벤트 가져오기") {
                    coordinator.fullCover(.eventImport)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadEvents()
        }
    }
}

@Observable
class CalendarViewModel {
    var events: [Event] = []
    var isLoading: Bool = false
    
    private let eventUseCase: EventUseCaseProtocol?
    
    init(eventUseCase: EventUseCaseProtocol?) {
        self.eventUseCase = eventUseCase
    }
    
    @MainActor
    func loadEvents() async {
        isLoading = true
        do {
            if let eventUseCase = eventUseCase {
                events = try await eventUseCase.getEvents()
            } else {
                // 임시 데이터
                events = []
            }
        } catch {
            print("Error loading calendar events: \(error)")
        }
        isLoading = false
    }
}
