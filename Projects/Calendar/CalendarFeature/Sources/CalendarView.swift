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
    
    public init(eventUseCase: EventUseCaseProtocol? = nil) {
        self._viewModel = State(wrappedValue: CalendarViewModel(eventUseCase: eventUseCase))
    }
    
    public var body: some View {
        VStack {
            LottieView(type: JSONFiles.Fire.self)
                .frame(width: 100, height: 100)
            
            Text("지훈")
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
