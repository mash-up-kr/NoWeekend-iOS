import Foundation
import SwiftUI
import Entity

// MARK: - Profile Builder Protocol
public protocol ProfileBuilder {
    func makeProfileView() -> AnyView
}
