import SwiftUI
import CoreLocation

struct GraphsView: View {
    var locationManager: LocationManager
    
    @State private var graphsData: ProData? = nil
    @State private var isLoading = false
    @State private var activeInfo: InfoPopupData? = nil
    
    
    var body: some View {
        ZStack() {
            Color(hex: "ede2d1").ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
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
                    // Оценка других пользователей
                    ZStack{
                        MyRectangle(width: 350, height: 110)
                        if let data = graphsData {
                            ProCommunityView(stats: data.communityReports, activeInfo: $activeInfo)
                        }
                        else {
                            ProgressView()
                        }
                    }
                    // Количество пыльцы в воздухе
                    ZStack{
                        MyRectangle(width: 350, height: 210)
                        if let data = graphsData{
                            ProActivityView(data: data, activeInfo: $activeInfo)
                        } else {
                            ProgressView()
                        }
                    }
                    // Столбчатая диаграмма долей
                    ZStack{
                        MyRectangle(width: 350, height: 200)
                        if let data = graphsData {
                            ProAllergensBarView(allergens: data.allergensLive, activeInfo: $activeInfo)
                        } else {
                            ProgressView()
                        }
                    }
                    // ГРАФИК
                    ZStack{
                        MyRectangle(width: 350, height: 270)
                        if let data = graphsData{
                            ProWeatherHourlyView(data: data, activeInfo: $activeInfo)
                        } else {
                            ProgressView()
                        }
                    }
                }
                //
            }
            if let info = activeInfo {
                InfoPopupView(info: info) { activeInfo = nil }
                    .transition(.opacity)
                    .animation(.easeInOut, value: activeInfo != nil)
            }
        }
        .task(id: locationManager.location?.latitude) {
            guard let loc = locationManager.location else { return }
            await updateData(lat: loc.latitude, lon: loc.longitude)

                }
                .refreshable {
                    if let loc = locationManager.location {
                        await updateData(lat: loc.latitude, lon: loc.longitude)
                    }
                }
    }
    private func updateData(lat: Double, lon: Double) async {
            graphsData = await loadProData(lat: lat, lon: lon)
            print("GraphsView: update \(lat), \(lon)")
    }
}
