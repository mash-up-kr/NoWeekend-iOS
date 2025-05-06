//
//  NetworkService.swift
//  NoWeekend
//
//  Created by 이지훈 on 4/25/25.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

protocol NetworkServiceProtocol {
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func post<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func put<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func delete<T: Decodable>(endpoint: String) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let headers: HTTPHeaders
    
    init(baseURL: String, headers: [String: String]) {
        self.baseURL = baseURL
        self.headers = HTTPHeaders(headers)
    }
    
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .get, parameters: parameters)
    }
    
    func post<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .post, parameters: parameters)
    }
    
    func put<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .put, parameters: parameters)
    }
    
    func delete<T: Decodable>(endpoint: String) async throws -> T {
        return try await request(endpoint: endpoint, method: .delete, parameters: nil)
    }
    
    private func request<T: Decodable>(endpoint: String, method: HTTPMethod, parameters: [String: Any]?) async throws -> T {
        let url = baseURL + endpoint
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.serverError(error.localizedDescription))
                }
            }
        }
    }
}
