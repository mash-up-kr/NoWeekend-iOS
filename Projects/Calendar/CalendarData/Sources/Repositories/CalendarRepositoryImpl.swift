//
//  CalendarRepositoryImpl.swift
//  CalendarData
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

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

}
