import SwiftUI
import HomeInterface
import Entity
import UseCase
import DesignSystem

// MARK: - Home View Implementation
public struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    public init(eventUseCase: EventUseCase) {
        self._viewModel = StateObject(wrappedValue: HomeViewModel(eventUseCase: eventUseCase))
    }
    
    public var body: some View {
        VStack {
            DS.Images.imgCake
            
            Text("나희")
                .font(Font.heading2)
                .foregroundColor(DS.Colors.Text.gray900)
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                LazyVStack {
                    ForEach(viewModel.events, id: \.id) { event in
                        Text(event.title)
                            .padding()
                    }
                }
            }
        }
        .task {
            await viewModel.loadEvents()
        }
    }
}

// MARK: - ViewModel Implementation
@MainActor
class HomeViewModel: ObservableObject, HomeProtocol {
    @Published var events: [Event] = []
    @Published var isLoading: Bool = false
    
    private let eventUseCase: EventUseCase
    
    init(eventUseCase: EventUseCase) {
        self.eventUseCase = eventUseCase
    }
    
    func loadEvents() async {
        isLoading = true
        do {
            events = try await eventUseCase.getEvents()
        } catch {
            print("Error loading events: \(error)")
        }
        isLoading = false
    }
    
    func refreshEvents() async {
        await loadEvents()
    }
}

// MARK: - Factory Implementation (Self-Registration)
public struct HomeViewFactory: HomeViewFactory {
    public static func create() -> AnyView {
        let eventUseCase = EventUseCase()
        return AnyView(HomeView(eventUseCase: eventUseCase))
    }
}

// MARK: - Self Registration (각 Feature가 스스로 등록)
@objc public class HomeFeatureModule: NSObject {
    @objc public static func register() {
        // DIContainer를 import하지 않고도 등록 가능
        // Runtime에 동적으로 등록
        if let containerClass = NSClassFromString("DIContainer"),
           let sharedMethod = containerClass.value(forKey: "shared") {
            // 동적으로 등록 로직 구현
            print("🏠 Home Feature: Self-registered")
        }
    }
}

#Preview {
    HomeViewFactory.create()
}
