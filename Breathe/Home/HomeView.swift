import SwiftUI
import CoreLocation

struct HomeView: View {
    @State private var homeData: HeadActivity?
    var locationManager: LocationManager
    
    var headerInfo = HeaderInfo()
    
    @State var isShowingCitySearch = false
    @State private var activeInfo: InfoPopupData? = nil
    
    var body: some View {
        ZStack {
            Color(hex: "ede2d1")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // MARK: -  Блок с датой и погодой и Лупой
                    HeaderView(locationManager: locationManager, headerInfo: headerInfo) {isShowingCitySearch = true}
                    
                    // MARK: - Плашка если нет города
                    if locationManager.authStatus == .denied && locationManager.location == nil {
                        NoSityViev()
                    }
                    // MARK: -  Блок с баллами
                    ActivityView(homeData: homeData, activeInfo: $activeInfo)

                    // MARK: -  Блок-Таблица с основными аллергенами
                    TableOfAllergens(homeData: homeData, activeInfo: $activeInfo)
                    
                    // MARK: -  Блок как вы себя чувствуете
                    FeelView(locationManager: locationManager, homeData: $homeData)
                }
                .padding(.top, 15)
            }
            
            if let info = activeInfo {
                InfoPopupView(info: info) {
                    activeInfo = nil
                }
                .transition(.opacity)
                .animation(.easeInOut, value: activeInfo != nil)
            }
            
        }
        // MARK: - Окно с городами
        .sheet(isPresented: $isShowingCitySearch) {
            CitySearchView { selectedCoordinate, selectedCityName in
                locationManager.setManualLocation(coordinate: selectedCoordinate, name: selectedCityName)
            }
            .presentationDetents([.medium, .large])
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        // MARK: - task,onChange
        .task(id: locationManager.location?.latitude) {
            // 1. Проверяем, есть ли вообще координаты
            guard let loc = locationManager.location else {
                if locationManager.authStatus == .authorizedWhenInUse || locationManager.authStatus == .authorizedAlways {
                    locationManager.fetchLocation()
                }
                return
            }
            
            homeData = await loadHomeData(lat: loc.latitude, lon: loc.longitude)
            print("HomeView: update \(loc.latitude), \(loc.longitude)")
        }
        .refreshable {
            // Принудительная загрузка данных (свайп вниз)
            if let loc = locationManager.location {
                homeData = await loadHomeData(lat: loc.latitude, lon: loc.longitude)
                print("HomeView: update \(loc.latitude), \(loc.longitude)")
            }
        }
    }
}

// MARK: - Доп функции
struct DateText: View {
    let text: String
    var body: some View {
        Text("\(text)")
            .font(.system(size: 15))
            .foregroundStyle(Color(hex: "37475a"))
    }
}
// MARK: - MyRectangle
struct MyRectangle: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: width, height: height)
            .foregroundStyle(Color(hex: "f9f7ed"))
    }
}

// MARK: - MiniRectangle
struct MiniRectangle: View {
    let width: CGFloat
    let height: CGFloat
    let color: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: width, height: height)
            .foregroundStyle(Color(hex: color))
    }
}
