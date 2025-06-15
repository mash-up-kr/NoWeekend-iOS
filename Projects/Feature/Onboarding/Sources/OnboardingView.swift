import SwiftUI
import Domain
import DesignSystem

public struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to NoWeekend",
            description: "Discover amazing events happening around you",
            imageName: "calendar"
        ),
        OnboardingPage(
            title: "Find Your Interests",
            description: "Search and filter events that match your preferences",
            imageName: "magnifyingglass"
        ),
        OnboardingPage(
            title: "Never Miss Out",
            description: "Get notifications for events you care about",
            imageName: "bell"
        )
    ]
    
    public init() {}
    
    public var body: some View {
        if showMainApp {
            // Navigate to main app
            Text("Main App Should Load Here")
        } else {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                VStack(spacing: 0) {
                    if currentPage == pages.count - 1 {
                        PrimaryButton(title: "Get Started") {
                            showMainApp = true
                        }
                    } else {
                        PrimaryButton(title: "Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }
                    
                    Button("Skip") {
                        showMainApp = true
                    }
                }
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 80))
//                .foregroundColor(Colors.primary)
            
            VStack(spacing: 0) {
                Text(page.title)
//                    .font(Typography.title)
                    .multilineTextAlignment(.center)
                
               
            }
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
