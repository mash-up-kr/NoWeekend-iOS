import Foundation

public protocol GoogleLoginUseCaseInterface {
    func execute() async throws -> LoginUser
}
