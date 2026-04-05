import SwiftUI

@main
struct BreatheApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                WelcomeView {
                    withAnimation { isFirstLaunch = false }
                }
            } else {
                MainTabView()
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
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

struct WelcomeView: View {
    var onFinish: () -> Void
    var body: some View {
        ZStack{
            Color(hex: "F9F8F6").ignoresSafeArea()
            
            Button {
                onFinish()
            } label: {
                Text("Начать")
            }
        }
    }
}
