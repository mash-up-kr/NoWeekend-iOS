import Foundation
import SwiftUI
import NeedleFoundation
import Entity

// MARK: - Home Dependency Protocol
public protocol HomeDependency: Dependency {
    // var userUseCase: UserUseCase { get }
    // var eventUseCase: EventUseCase { get }
}

// MARK: - Home Builder Protocol
public protocol HomeBuilder {
    func makeHomeView() -> AnyView
}
