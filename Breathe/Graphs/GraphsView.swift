import SwiftUI
import CoreLocation

struct GraphsView: View {
    var locationManager: LocationManager
    
    @State private var graphsData: ProData? = nil
    @State private var isLoading = false
    @State private var activeInfo: InfoPopupData? = nil
    
    // Добавляем кэш последней локации, как в HomeView
    @State private var lastLoadedCoords: String = ""
    
    var body: some View {
        ZStack {
            Color(hex: "ede2d1").ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Заголовок
                    HStack {
                        Text("Аналитика")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(Color(hex: "37475a"))
                        Spacer()
                        Image(systemName: "chart.bar.xaxis")
                            .foregroundStyle(Color(hex: "ff893f"))
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    
                    // Количество пыльцы в воздухе
                    ZStack{
                        MyRectangle(width: 350, height: 210)
                        if let data = graphsData{
                            ProActivityView(data: data, activeInfo: $activeInfo)
                        } else {
                            ProgressView()
                        }
                    }
                    
                    // ГРАФИК
                    ZStack{
                        MyRectangle(width: 350, height: 280)
                        if let data = graphsData{
                            WeatherHourlyView(data: data, activeInfo: $activeInfo)
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
            if let info = activeInfo {
                InfoPopupView(info: info) { activeInfo = nil }
                    .transition(.opacity)
                    .animation(.easeInOut, value: activeInfo != nil)
            }
        }
        .task(id: locationManager.location?.latitude) {
                    guard let loc = locationManager.location else { return }
                    let currentCoords = "\(loc.latitude),\(loc.longitude)"
                    
                    if graphsData != nil && lastLoadedCoords == currentCoords {
                        return
                    }
                    
                    await updateData(lat: loc.latitude, lon: loc.longitude)
                    lastLoadedCoords = currentCoords
                }
                .refreshable {
                    if let loc = locationManager.location {
                        await updateData(lat: loc.latitude, lon: loc.longitude)
                        lastLoadedCoords = "\(loc.latitude),\(loc.longitude)"
                    }
                }
    }
    private func updateData(lat: Double, lon: Double) async {
            graphsData = await loadProData(lat: lat, lon: lon)
            print("GraphsView: Данные загружены для \(lat), \(lon)")
    }
}
