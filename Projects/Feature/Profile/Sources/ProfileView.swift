import SwiftUI
import ProfileInterface
import Entity
import UseCase
import DesignSystem

// MARK: - Profile View Implementation
public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    
    public init(userUseCase: UserUseCase) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(userUseCase: userUseCase))
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Profile Header
            VStack {
                DS.Images.imgStar
                    .frame(width: 80, height: 80)
                
                if let user = viewModel.user {
                    Text(user.name)
                        .font(Font.heading1)
                        .foregroundColor(DS.Colors.Text.gray900)
                    
                    Text(user.email)
                        .font(Font.body1)
                        .foregroundColor(DS.Colors.Text.gray700)
                }
            }
            
            // Profile Settings
            if viewModel.isLoading {
                ProgressView()
            } else {
                VStack(spacing: 16) {
                    ProfileSettingRow(title: "테마 설정", value: viewModel.currentTheme.rawValue)
                    ProfileSettingRow(title: "알림 설정", value: viewModel.isNotificationsEnabled ? "ON" : "OFF")
                    ProfileSettingRow(title: "언어", value: viewModel.language)
                }
                .padding()
            }
            
            Spacer()
        }
        .task {
            await viewModel.loadProfile()
        }
    }
}

// MARK: - Profile Setting Row
private struct ProfileSettingRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(Font.body1)
                .foregroundColor(DS.Colors.Text.gray900)
            
            Spacer()
            
            Text(value)
                .font(Font.body2)
                .foregroundColor(DS.Colors.Text.gray700)
            
            DS.Images.icnChevronRight
                .frame(width: 16, height: 16)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - ViewModel Implementation
@MainActor
class ProfileViewModel: ObservableObject, ProfileProtocol {
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var currentTheme: Theme = .system
    @Published var isNotificationsEnabled: Bool = true
    @Published var language: String = "한국어"
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
    }
    
    func loadProfile() async {
        isLoading = true
        do {
            let profile = try await userUseCase.getCurrentUserProfile()
            user = profile.user
            currentTheme = profile.preferences.theme
            isNotificationsEnabled = profile.preferences.notificationsEnabled
            language = profile.preferences.language
        } catch {
            print("Error loading profile: \(error)")
        }
        isLoading = false
    }
    
    func updateTheme(_ theme: Theme) async {
        currentTheme = theme
        // TODO: UserUseCase를 통해 테마 업데이트
    }
    
    func toggleNotifications() async {
        isNotificationsEnabled.toggle()
        // TODO: UserUseCase를 통해 알림 설정 업데이트
    }
}

// MARK: - Factory Implementation
public struct ProfileViewFactory: ProfileViewFactory {
    public static func create() -> AnyView {
        let userUseCase = UserUseCase()
        return AnyView(ProfileView(userUseCase: userUseCase))
    }
}

#Preview {
    ProfileViewFactory.create()
}
