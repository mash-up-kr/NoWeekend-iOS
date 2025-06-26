import Foundation
import SwiftUI
import NeedleFoundation
import Entity

// MARK: - Profile Dependency Protocol
public protocol ProfileDependency: Dependency {
    // var userUseCase: UserUseCase { get }
}

// MARK: - Profile Builder Protocol
public protocol ProfileBuilder {
    func makeProfileView() -> AnyView
}
