import SwiftUI
import Domain

public protocol ProfileProtocol: ObservableObject {
    var user: User? { get }
    var isLoading: Bool { get }
    
    func loadUserProfile() async
    func updateProfile(name: String, email: String) async
}

public protocol ProfileCoordinatorProtocol {
    func navigateToSettings()
    func navigateToEditProfile()
}
