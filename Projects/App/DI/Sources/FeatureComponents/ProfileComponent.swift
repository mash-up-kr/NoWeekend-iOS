import NeedleFoundation
import Profile
import ProfileInterface

// MARK: - Profile Component (Builder 구현)
final class ProfileComponent: Component<ProfileDependency>, ProfileBuilder {
    
    func makeProfileView() -> AnyView {
        return AnyView(ProfileView())
    }
}