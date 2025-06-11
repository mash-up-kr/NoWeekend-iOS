import Foundation
import Domain


public protocol LoginWithGoogleUseCaseInterface {
    func execute(accessToken: String, name: String?) async throws -> LoginEntity
}
