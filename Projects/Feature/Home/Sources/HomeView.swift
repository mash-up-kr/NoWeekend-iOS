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
class HomeViewModel: ObservableObject {
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
