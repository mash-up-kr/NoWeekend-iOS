import Foundation
import Domain


public protocol GoogleLoginUseCaseInterface {
    func execute() async throws -> LoginUser
}
