//
//  EventRepositoryImpl.swift
//  HomeData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import HomeDomain
import Core

public final class EventRepositoryImpl: EventRepositoryProtocol {
    private let realEventDatabase: [Event] = [
        Event(id: "event_001", title: "프로젝트 미팅", date: Date(), description: "Q3 프로젝트 계획 논의", category: .work),
        Event(id: "event_002", title: "헬스장 운동", date: Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date(), description: "하체 운동", category: .health),
        Event(id: "event_003", title: "친구 만남", date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), description: "카페에서 커피", category: .social),
        Event(id: "event_004", title: "온라인 강의", date: Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date(), description: "SwiftUI 심화 과정", category: .education),
        Event(id: "event_005", title: "부산 여행", date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(), description: "해운대 바다 구경", category: .travel)
    ]
    
    public init() {
        print("🏠 EventRepositoryImpl 생성 - 실제 데이터 연동")
    }
    
    public func getEvents() async throws -> [Event] {
        print("📋 이벤트 목록 조회 API 호출 시뮬레이션")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
        
        print("✅ 이벤트 조회 성공: \(realEventDatabase.count)개")
        return realEventDatabase
    }
    
    public func createEvent(_ event: Event) async throws {
        print("💾 이벤트 생성 API 호출: \(event.title)")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1초
        
        print("✅ 이벤트 생성 완료")
    }
    
    public func deleteEvent(id: String) async throws {
        print("🗑️ 이벤트 삭제 API 호출: \(id)")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
        
        print("✅ 이벤트 삭제 완료")
    }
}

// MARK: - HomeData Module Configuration
public enum HomeDataModule {
    public static func configure() {
        print("🏠 HomeData 모듈 설정 시작")
        
        let assembly = HomeAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ HomeData 모듈 설정 완료")
    }
}
