//
//  NetworkService.swift
//  Core
//
//  Created by 이지훈 on 7/3/25.
//  Copyright © 2025 com.noweekend. All rights reserved.
//

import Alamofire
import Foundation

public protocol NWNetworkServiceProtocol {
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func post<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func put<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func delete<T: Decodable>(endpoint: String) async throws -> T
}

public class NWNetworkService: NWNetworkServiceProtocol {
    private let baseURL: String
    private let session: Session
    
    public init(baseURL: String = Config.baseURL, headers: [String: String] = [:]) {
        self.baseURL = baseURL
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        self.session = Session(configuration: configuration)
    }
    
    public func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T {
        try await request(endpoint: endpoint, method: .get, parameters: parameters)
    }
    
    public func post<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T {
        try await request(endpoint: endpoint, method: .post, parameters: parameters)
    }
    
    public func put<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T {
        try await request(endpoint: endpoint, method: .put, parameters: parameters)
    }
    
    public func delete<T: Decodable>(endpoint: String) async throws -> T {
        try await request(endpoint: endpoint, method: .delete, parameters: nil)
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
