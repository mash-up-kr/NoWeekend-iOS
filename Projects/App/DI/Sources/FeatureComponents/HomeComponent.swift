import NeedleFoundation
import Home
import HomeInterface

// MARK: - Home Component (Builder 구현)
final class HomeComponent: Component<HomeDependency>, HomeBuilder {
    
    func makeHomeView() -> AnyView {
        return AnyView(HomeView())
    }
}