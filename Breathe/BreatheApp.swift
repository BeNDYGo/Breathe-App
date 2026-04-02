import SwiftUI

@main
struct BreatheApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", image: "Дом")
                    }
                
                GraphsView()
                    .tabItem {
                        Label("Graphs", image: "График")
                    }
                    .badge("pro")

                GameView()
                    .tabItem {
                        Label("Game", image: "Дерево")
                    }
            }
            .tint(Color(hex: "ff893f"))
        }
    }
}
