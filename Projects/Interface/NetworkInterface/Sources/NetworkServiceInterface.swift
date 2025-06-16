import Foundation

public protocol NetworkServiceInterface {
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func post<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func put<T: Decodable>(endpoint: String, parameters: [String: Any]?) async throws -> T
    func delete<T: Decodable>(endpoint: String) async throws -> T
}
