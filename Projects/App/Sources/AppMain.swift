import SwiftUI
import Login

@main
struct AppMain: App {
    var body: some Scene {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        
        WindowGroup {
            ContentView()
        }
    }
}
