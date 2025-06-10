import Foundation

// MARK: - User Entity
public struct User: Codable, Identifiable {
    public let id: String
    public let name: String
    public let email: String
    
    public init(id: String, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }
}

// MARK: - Event Entity
public struct Event: Codable, Identifiable {
    public let id: String
    public let title: String
    public let date: Date
    public let description: String?
    
    public init(id: String, title: String, date: Date, description: String? = nil) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
    }
}
