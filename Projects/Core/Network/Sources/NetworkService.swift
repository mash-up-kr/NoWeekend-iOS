import Foundation
import Alamofire
import NetworkInterface
import Common

public class NetworkService: NetworkServiceProtocol {
    private let baseURL: String
    private let headers: HTTPHeaders
    
    public init(baseURL: String, headers: [String: String]) {
        self.baseURL = baseURL
        self.headers = HTTPHeaders(headers)
    }
    
    public func get<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .get, parameters: parameters)
    }
    
    public func post<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .post, parameters: parameters)
    }
    
    public func put<T: Decodable>(endpoint: String, parameters: [String: Any]? = nil) async throws -> T {
        return try await request(endpoint: endpoint, method: .put, parameters: parameters)
    }
    
    public func delete<T: Decodable>(endpoint: String) async throws -> T {
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
