//
//  CalendarRepositoryImpl.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import CalendarDomain
import Core

public final class CalendarRepositoryImpl: CalendarRepositoryProtocol {
    private let realCalendarDatabase: [CalendarEvent] = [
        CalendarEvent(
            id: "cal_001", 
            title: "팀 회의", 
            startDate: Date(), 
            endDate: Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date(),
            description: "주간 팀 회의",
            category: .work
        ),
        CalendarEvent(
            id: "cal_002", 
            title: "운동", 
            startDate: Calendar.current.date(byAdding: .hour, value: 2, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .hour, value: 3, to: Date()) ?? Date(),
            description: "헬스장 운동",
            category: .health
        )
    ]
    
    public init() {
        print("📅 CalendarRepositoryImpl 생성")
    }
    
    public func getCalendarEvents() async throws -> [CalendarEvent] {
        print("📅 캘린더 이벤트 조회 API 호출")
        
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000)
        
        print("✅ 캘린더 이벤트 조회 성공: \(realCalendarDatabase.count)개")
        return realCalendarDatabase
    }
    
    public func getEventsForDate(_ date: Date) async throws -> [CalendarEvent] {
        let events = try await getCalendarEvents()
        return events.filter { Calendar.current.isDate($0.startDate, inSameDayAs: date) }
    }
    
    public func createCalendarEvent(_ event: CalendarEvent) async throws {
        print("💾 캘린더 이벤트 생성: \(event.title)")
        try await Task.sleep(nanoseconds: 1_000_000_000)
        print("✅ 캘린더 이벤트 생성 완료")
    }
    
    public func updateCalendarEvent(_ event: CalendarEvent) async throws {
        print("📝 캘린더 이벤트 업데이트: \(event.title)")
        try await Task.sleep(nanoseconds: 500_000_000)
        print("✅ 캘린더 이벤트 업데이트 완료")
    }
    
    public func deleteCalendarEvent(id: String) async throws {
        print("🗑️ 캘린더 이벤트 삭제: \(id)")
        try await Task.sleep(nanoseconds: 500_000_000)
        print("✅ 캘린더 이벤트 삭제 완료")
    }
}

// MARK: - CalendarData Module Configuration
public enum CalendarDataModule {
    public static func configure() {
        print("📅 CalendarData 모듈 설정 시작")
        
        let assembly = CalendarAssembly()
        DIContainer.shared.registerAssembly(assembly: [assembly])
        
        print("✅ CalendarData 모듈 설정 완료")
    }
}
