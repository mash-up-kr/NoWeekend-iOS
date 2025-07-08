//
//  NetworkError.swift
//  CalendarInterface
//
//  Created by 김시종 on 6/28/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation

public enum NetworkError: LocalizedError {
    case serverError(String)
    case decodingError
    case notImplemented(String)
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return message
        case .decodingError:
            return "응답 디코딩에 실패했습니다."
        case .notImplemented(let message):
            return message
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
