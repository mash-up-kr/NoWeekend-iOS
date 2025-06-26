import Foundation

// MARK: - User Entity
public struct User: Codable, Identifiable, Equatable {
    public let id: String
    public let name: String
    public let email: String
    public let profileImageURL: String?
    public let createdAt: Date
    
    public init(
        id: String, 
        name: String, 
        email: String, 
        profileImageURL: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageURL = profileImageURL
        self.createdAt = createdAt
    }
}

// MARK: - User Profile
public struct UserProfile: Codable {
    public let user: User
    public let preferences: UserPreferences
    
    public init(user: User, preferences: UserPreferences) {
        self.user = user
        self.preferences = preferences
    }
}

// MARK: - User Preferences
public struct UserPreferences: Codable {
    public let theme: Theme
    public let notificationsEnabled: Bool
    public let language: String
    
    public init(
        theme: Theme = .light,
        notificationsEnabled: Bool = true,
        language: String = "ko"
    ) {
        self.theme = theme
        self.notificationsEnabled = notificationsEnabled
        self.language = language
    }
}

// MARK: - Theme
public enum Theme: String, Codable, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
} 