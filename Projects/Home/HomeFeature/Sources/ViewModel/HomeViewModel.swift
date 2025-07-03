//
//  HomeViewModel.swift
//  HomeFeature
//
//  Created by 이지훈 on 7/3/25.
//

import Foundation
import HomeDomain
import Core
import Combine

public final class HomeViewModel: ObservableObject {
    @Dependency private var eventUseCase: EventUseCaseProtocol
    @Published public var events: [Event] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        print("🏠 HomeViewModel 생성 - @Dependency 방식")
    }
    
    var todayEvents: [Event] {
        let today = Date()
        return events.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    var recentEvents: [Event] {
        return events.sorted { $0.date > $1.date }
    }
    
    @MainActor
    public func loadEvents() async {
        isLoading = true
        errorMessage = ""
        
        do {
            let loadedEvents = try await eventUseCase.getEvents()
            events = loadedEvents
            print("📋 이벤트 데이터 로드 완료: \(loadedEvents.count)개")
        } catch {
            errorMessage = "이벤트를 불러올 수 없습니다."
            print("❌ 이벤트 로드 실패: \(error)")
        }
        
        isLoading = false
    }
}
