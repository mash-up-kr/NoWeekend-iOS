import SwiftUI
import Domain
import DesignSystem
import Common

public struct LoginView: View {
    @StateObject private var store: LoginStore
    
    public init(store: LoginStore) {
        self._store = StateObject(wrappedValue: store)
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "paperplane")
                .frame(width: 287, height: 287)
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    store.send(.signInWithApple)
                }) {
                    HStack {
                        if store.state.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "applelogo")
                        }
            
                        Text("Apple 계정으로 시작")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .disabled(store.state.isLoading)
                
                Button(action: {
                    store.send(.signInWithGoogle)
                }) {
                    HStack {
                        if store.state.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "globe")
                        }
                        
                        Text("Google 계정으로 시작")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .disabled(store.state.isLoading)
            }
            
            if !store.state.errorMessage.isEmpty {
                Text(store.state.errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .onReceive(store.effect) { effect in
            switch effect {
            case .showError(let message):
                print("Error: \(message)")
            case .navigateToHome:
                print("Navigate to HOme")
            }
        }
    }
}
