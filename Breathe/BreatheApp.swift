import SwiftUI

@main
struct BreatheApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                
                GameView()
                    .tabItem {
                        Label("Game", systemImage: "tree.fill")
                    }
            }
        }
    }
}

