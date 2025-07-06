//
//  NetworkService.swift
//  Core
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkServiceProtocol {
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func post<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func put<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func delete<T: Decodable>(endpoint: String) async throws -> T
}

public class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let session: Session
    
    public init(baseURL: String = Config.baseURL, headers: [String: String] = [:]) {
        self.baseURL = baseURL
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Session(configuration: configuration)
    }
    
    public func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T {
        return try await request(endpoint: endpoint, method: .get, parameters: parameters)
    }
    
    public func post<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T {
        return try await request(endpoint: endpoint, method: .post, parameters: parameters)
    }
    
    public func put<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T {
        return try await request(endpoint: endpoint, method: .put, parameters: parameters)
    }
    
    public func delete<T: Decodable>(endpoint: String) async throws -> T {
        return try await request(endpoint: endpoint, method: .delete, parameters: nil)
    }
    
    private func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: Any]?
    ) async throws -> T {
        let url = baseURL + endpoint
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Network Error
public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(String)
    case encodingError(String)
    case serverError(String)
    case unauthorized
    case forbidden
    case notFound
    case timeout
    case noInternetConnection
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터가 없습니다."
        case .decodingError(let message):
            return "데이터 변환 오류: \(message)"
        case .encodingError(let message):
            return "데이터 인코딩 오류: \(message)"
        case .serverError(let message):
            return "서버 오류: \(message)"
        case .unauthorized:
            return "인증이 필요합니다."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "리소스를 찾을 수 없습니다."
        case .timeout:
            return "요청 시간을 초과했습니다."
        case .noInternetConnection:
            return "인터넷 연결을 확인해주세요."
        }
    }
}
