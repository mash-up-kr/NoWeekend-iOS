//
//  CalendarRepositoryImpl.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import CalendarDomain
import NWNetwork

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
        
        do {
            let response: ScheduleResponse = try await networkService.get(
                endpoint: "/schedule",
                parameters: parameters
            )
            
            guard response.result == "SUCCESS" else {
                throw NetworkError.serverError(response.error?.message ?? "Unknown error")
            }
            
            return response.data.map { $0.toDomain() }
        } catch {
            print("네트워크 에러: \(error)")
            throw error
        }
    }
}
