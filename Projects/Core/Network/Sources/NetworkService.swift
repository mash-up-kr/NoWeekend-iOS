import Foundation
import Alamofire
import NetworkInterface

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
        
        print("🌐 Network Request:")
        print("  - URL: \(url)")
        print("  - Method: \(method)")
        print("  - Headers: \(headers)")
        print("  - Parameters: \(parameters ?? [:])")
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseData { response in  // 🔥 responseData로 변경하여 원본 데이터 확인
                print("🌐 Network Response:")
                print("  - Status Code: \(response.response?.statusCode ?? 0)")
                print("  - Headers: \(response.response?.allHeaderFields ?? [:])")
                
                switch response.result {
                case .success(let data):
                    print("  - Response Data: \(String(data: data, encoding: .utf8) ?? "nil")")
                    
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        print("❌ Decoding Error: \(error)")
                        continuation.resume(throwing: NetworkError.decodingError)
                    }
                    
                case .failure(let error):
                    print("❌ Network Error: \(error)")
                    print("  - Error Description: \(error.localizedDescription)")
                    if let data = response.data {
                        print("  - Error Response: \(String(data: data, encoding: .utf8) ?? "nil")")
                    }
                    continuation.resume(throwing: NetworkError.serverError(error.localizedDescription))
                }
            }
        }
    }
}
