import Foundation

// MARK: - Event Entity  
public struct Event: Codable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public let date: Date
    public let description: String?
    public let category: EventCategory
    public let isCompleted: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    public init(
        id: String, 
        title: String, 
        date: Date, 
        description: String? = nil,
        category: EventCategory = .other,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.description = description
        self.category = category
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Event Category
public enum EventCategory: String, Codable, CaseIterable {
    case work = "work"
    case personal = "personal"
    case health = "health"
    case education = "education"
    case social = "social"
    case travel = "travel"
    case other = "other"
    
    public var displayName: String {
        switch self {
        case .work: return "업무"
        case .personal: return "개인"
        case .health: return "건강"
        case .education: return "교육"
        case .social: return "사회"
        case .travel: return "여행"
        case .other: return "기타"
        }
    }
    
    public var color: String {
        switch self {
        case .work: return "blue"
        case .personal: return "green"
        case .health: return "red"
        case .education: return "purple"
        case .social: return "orange"
        case .travel: return "teal"
        case .other: return "gray"
        }
    }
}

// MARK: - Calendar Event
public struct CalendarEvent: Codable, Identifiable {
    public let id: String
    public let event: Event
    public let startTime: Date
    public let endTime: Date
    public let isAllDay: Bool
    public let reminder: EventReminder?
    
    public init(
        id: String,
        event: Event,
        startTime: Date,
        endTime: Date,
        isAllDay: Bool = false,
        reminder: EventReminder? = nil
    ) {
        self.id = id
        self.event = event
        self.startTime = startTime
        self.endTime = endTime
        self.isAllDay = isAllDay
        self.reminder = reminder
    }
}

// MARK: - Event Reminder
public struct EventReminder: Codable {
    public let minutesBefore: Int
    public let isEnabled: Bool
    
    public init(minutesBefore: Int, isEnabled: Bool = true) {
        self.minutesBefore = minutesBefore
        self.isEnabled = isEnabled
    }
    
    public static let defaultReminders = [
        EventReminder(minutesBefore: 5),
        EventReminder(minutesBefore: 15),
        EventReminder(minutesBefore: 30),
        EventReminder(minutesBefore: 60)
    ]
} 