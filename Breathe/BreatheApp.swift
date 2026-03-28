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
                
                GraphsView()
                    .tabItem {
                        Label("Graphs", systemImage: "graph.2d")
                    }
                    .badge("pro")

                GameView()
                    .tabItem {
                        Label("Game", systemImage: "tree.fill")
                    }
            }
            .tint(Color(hex: "15de07"))
        }
    }
}
