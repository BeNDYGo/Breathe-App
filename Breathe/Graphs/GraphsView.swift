import SwiftUI
import CoreLocation

struct GraphsView: View {
    var locationManager: LocationManager
    
    @State private var graphsData: ProData? = nil
    @State private var isLoading = false
    @State private var activeInfo: InfoPopupData? = nil

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
                    if let data = graphsData{
                        ProActivityView(data: data, activeInfo: $activeInfo)
                    } else {
                        ProgressView()
                    }
                    
                    // ГРАФИК
                    if let data = graphsData{
                        WeatherHourlyView(data: data, activeInfo: $activeInfo)
                    } else {
                        ProgressView()
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
            if graphsData == nil {
                await updateData()
            } else {
                return
            }
        }
        .refreshable {
            await updateData()
        }
    }
    
    private func updateData() async {
        if let loc = locationManager.location {
            graphsData = await loadProData(lat: loc.latitude, lon: loc.longitude)
            print("Update")
        }
    }
}
