import Foundation
import Domain

// MARK: - Analytics Service Protocol
public protocol AnalyticsServiceProtocol {
    func track(event: String, parameters: [String: Any]?)
    func setUserId(_ userId: String)
}

// MARK: - Push Notification Service Protocol
public protocol PushNotificationServiceProtocol {
    func registerForPushNotifications()
    func handlePushNotification(userInfo: [AnyHashable: Any])
}

// MARK: - Authentication Service Protocol
public protocol AuthenticationServiceProtocol {
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    func getCurrentUser() async throws -> User?
}
