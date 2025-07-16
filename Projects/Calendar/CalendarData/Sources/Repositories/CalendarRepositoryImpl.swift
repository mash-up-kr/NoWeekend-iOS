//
//  CalendarRepositoryImpl.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import CalendarDomain
import Foundation
import NWNetwork
import Utils

public enum NetworkError: Error {
    case serverError(String)
    case networkError(String)
    case unknown
}

public final class CalendarRepositoryImpl: CalendarRepositoryProtocol {
    private let networkService: NWNetworkServiceProtocol
    
    public init(networkService: NWNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    public func getSchedules(startDate: String, endDate: String) async throws -> [DailySchedule] {
        let parameters = [
            "start_date": startDate,
            "end_date": endDate
        ]
        
        let response: ScheduleResponseDTO = try await networkService.get(
            endpoint: "/schedule",
            parameters: parameters
        )
        
        guard response.result == "SUCCESS" else {
            let errorMessage = response.error?.message ?? "API 실패"
            throw NetworkError.serverError(errorMessage)
        }
        
        return response.data.map { $0.toDomain() }
    }
    
    public func createSchedule(request: CreateScheduleRequest) async throws -> Schedule {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone.current
        
        let requestDTO = CreateScheduleRequestDTO(
            title: request.title,
            date: dateFormatter.string(from: request.date),
            startTime: timeFormatter.string(from: request.startTime),
            endTime: timeFormatter.string(from: request.endTime),
            category: request.category.rawValue,
            temperature: request.temperature,
            allDay: request.allDay,
            alarmOption: request.alarmOption.rawValue
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(requestDTO)
        guard let parameters = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkError.networkError("Failed to serialize parameters")
        }
        
        let response: CreateScheduleResponseDTO = try await networkService.post(
            endpoint: "/schedule",
            parameters: parameters
        )
        
        guard response.result == "SUCCESS", let data = response.data else {
            let errorMessage = response.error?.message ?? "일정 생성 실패"
            print("❌ 일정 생성 실패: \(errorMessage)")
            throw NetworkError.serverError(errorMessage)
        }
        
        let schedule = data.toDomain()
        print("✅ 일정 생성 성공: \(schedule.title)")
        return schedule
    }
    
    public func updateSchedule(id: String, request: UpdateScheduleRequest) async throws -> Schedule {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone.current
        
        let requestDTO = UpdateScheduleRequestDTO(
            title: request.title,
            startTime: timeFormatter.string(from: request.startTime),
            endTime: timeFormatter.string(from: request.endTime),
            category: request.category.rawValue,
            temperature: request.temperature,
            allDay: request.allDay,
            alarmOption: request.alarmOption.rawValue
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(requestDTO)
        guard let parameters = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NetworkError.networkError("Failed to serialize parameters")
        }
        
        let response: UpdateScheduleAPIResponseDTO = try await networkService.put(
            endpoint: "/schedule/\(id)",
            parameters: parameters
        )
        
        guard response.result == "SUCCESS", let data = response.data else {
            let errorMessage = response.error?.message ?? "일정 수정 실패"
            print("❌ 일정 수정 실패: \(errorMessage)")
            throw NetworkError.serverError(errorMessage)
        }
        
        let schedule = data.toDomain()
        print("✅ 일정 수정 성공: \(schedule.title)")
        return schedule
    }
    
    public func deleteSchedule(id: String) async throws {
        let response: DeleteScheduleResponseDTO = try await networkService.delete(
            endpoint: "/schedule/\(id)"
        )
        
        guard response.result == "SUCCESS" else {
            let errorMessage = response.error?.message ?? "일정 삭제 실패"
            throw NetworkError.serverError(errorMessage)
        }
    }
    
    public func getRecommendedTags() async throws -> RecommendTagResponse {
        let response: RecommendTagResponse = try await networkService.get(
            endpoint: "/recommend/todo/mixed",
            parameters: [:]
        )
        
        return response
    }
    
    public func updateScheduleState(id: String, isComplete: Bool) async throws -> Schedule {
        let endpoint = "/schedule/\(id)/state?is_complete=\(isComplete)"
        
        let response: UpdateScheduleStateResponseDTO = try await networkService.put(
            endpoint: endpoint,
            parameters: nil  
        )
        
        guard response.result == "SUCCESS", let data = response.data else {
            let errorMessage = response.error?.message ?? "일정 상태 업데이트 실패"
            print("❌ 일정 상태 업데이트 실패: \(errorMessage)")
            throw NetworkError.serverError(errorMessage)
        }
        
        let schedule = data.toDomain()
        print("✅ 일정 상태 업데이트 성공: \(schedule.title), 완료: \(schedule.completed)")
        return schedule
    }
}
