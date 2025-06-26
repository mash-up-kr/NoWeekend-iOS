import Foundation
import SwiftUI
import Entity


// MARK: - Home Builder Protocol
public protocol HomeBuilder {
    func makeHomeView() -> AnyView
}
