import SwiftUI
let Orange = "ff893f"

@main
struct BreatheApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @State private var locationManager = LocationManager()
    @State private var onboardingStep: Int = 0

    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                if onboardingStep == 0 {
                    WelcomeView {
                        withAnimation { onboardingStep = 1 }
                    }
                } else if onboardingStep == 1 {
                    OnboardingLocationView(locationManager: locationManager) {
                        withAnimation { isFirstLaunch = false }
                    }
                }
                
            } else {
                MainTabView(locationManager: locationManager)
            }
        }
    }
}

struct MainTabView: View {
    var locationManager: LocationManager
    @State private var AIRequests: Int = 5
    
    var body: some View {
        TabView {
            HomeView(locationManager: locationManager)
                .tabItem { Label("Home", image: "Дом") }
            
            GraphsView(locationManager: locationManager)
                .tabItem { Label("Graphs", image: "График") }
                .badge("pro")
            
            AiChatView(remainingRequests: AIRequests, locationManager: locationManager)
                .tabItem { Label("AI", image: "Дерево") }
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
