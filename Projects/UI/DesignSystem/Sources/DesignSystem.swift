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
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
        }
    }
}

// MARK: - Custom Text Field
public struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    public init(placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    public var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
    }
}
