import SwiftUI
import CoreLocation

struct HomeView: View {
    @State private var homeData: HeadActivity?
    @State private var locationManager = LocationManager()
    
    var headerInfo = HeaderInfo()
    
    @State private var isShowingCitySearch = false
    
    @AppStorage("hasSeenPrompt") private var hasSeenPrompt = false
    
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
                    ActivityView(homeData: homeData)

                    // MARK: -  Блок-Таблица с основными аллергенами
                    TableOfAllergens(homeData: homeData)
                    
                    // MARK: -  Блок как вы себя чувствуете
                    FeelView()
                }
                .padding(.top, 15)
            }
            
            // MARK: - окно предупреждения о GPS
            if !hasSeenPrompt && locationManager.authStatus == .notDetermined {
                LocationPromptView {
                    // Действия при нажатии на кнопку "Далее":
                    hasSeenPrompt = true // 1. Запоминаем, что окно показали
                    locationManager.requestPermission() // 2. Вызываем СИСТЕМНОЕ окно Apple
                }
                .transition(.opacity)
                .animation(.easeInOut, value: hasSeenPrompt)
            }
        }
        // MARK: - Окно с городами
        .sheet(isPresented: $isShowingCitySearch) {
            // Теперь мы получаем и координаты, и ИМЯ
            CitySearchView { selectedCoordinate, selectedCityName in
                
                // Передаем всё в менеджер.
                // Текст на экране изменится на "Москва" МГНОВЕННО, без тупых геокодеров.
                locationManager.setManualLocation(coordinate: selectedCoordinate, name: selectedCityName)
                
            }
            .presentationDetents([.medium, .large])
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        // MARK: - task,onChange
        .task(id: locationManager.location?.latitude) {
            // Если у нас уже есть координаты (нашел GPS или загрузили из памяти)
            if let loc = locationManager.location {
                homeData = await loadHomeData(lat: loc.latitude, lon: loc.longitude)
            } else if locationManager.authStatus == .authorizedWhenInUse {
                // Если разрешение есть, но координат еще нет - просим найти
                locationManager.fetchLocation()
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

// MARK: - Ячейка Аллергена
struct AllergenCell: View {
    let name: String
    let iconName: String
    let value: Int
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(iconName)
                        .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    Text(name)
                        .foregroundStyle(Color(hex: "37475a"))
                        .lineLimit(1)
                        .font(.system(size: 15))
                    Spacer()
                }
                .padding(.leading, 10)
                
                ProgressView(value: Double(value), total: 10)
                    .frame(width: 110)
                    .tint(Color(hex: allergenColor(value: value)))
            }
        }
        // Жестко фиксируем размер, чтобы ничего никуда не уехало!
        .frame(width: 145, height: 55)
    }
}

// MARK: - Окно с GPS
struct LocationPromptView: View {
    // Эта переменная будет хранить действие, которое произойдет при нажатии кнопки
    var onNextAction: () -> Void
    
    var body: some View {
        ZStack {
            // 1. Полупрозрачный темный фон на весь экран
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            // 2. Сама карточка по центру
            VStack(spacing: 20) {
                Image(systemName: "location.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.green) // Можете поменять на свой цвет
                
                Text("Нам нужен доступ к геолокации, чтобы узнать ваш город")
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                
                Button {
                    // Вызываем переданное действие
                    onNextAction()
                } label: {
                    Text("Далее")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "15de07")) // Ваш зеленый цвет
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 10)
            }
            .padding(25)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.horizontal, 40) // Отступы карточки от краев экрана
        }
    }
}

#Preview {
    HomeView()
}
