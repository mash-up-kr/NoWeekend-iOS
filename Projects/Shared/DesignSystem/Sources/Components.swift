import SwiftUI

// MARK: - Primary Button
public struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
//                .font(Font.body2.)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
//                .background(Colors.primary)
//                .cornerRadius(UIConstants.cornerRadius)
        }
    }
}

// MARK: - Card View
public struct CardView<Content: View>: View {
    let content: Content
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            content
        }
//        .padding(Spacing.md)
//        .background(Colors.background)
//        .cornerRadius(UIConstants.cornerRadius)
        .shadow(radius: 2)
    }
}
