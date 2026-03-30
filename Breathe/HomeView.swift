
import SwiftUI
import CoreLocation

struct HomeView: View {
    var headerInfo = HeaderInfo()
    
    @State private var homeData: HeadActivity?
    @State private var locationManager = LocationManager()
    
    @State private var isShowingCitySearch = false
    @State private var showLocationPrompt = true
    
    
    var body: some View {
        ZStack {
            Color(hex: "F9F8F6")
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
// MARK: -  Блок с датой и погодой
                    ZStack {
                        MyRectangle(width: 350, height: 70)

                        HStack() {
                            VStack(alignment: .leading) {
                                Text("\(homeData?.city ?? "Город")")
                                    .font(.system(size: 20).bold())
                                HStack{
                                    DateText(text: headerInfo.dayNumber)
                                    DateText(text: headerInfo.weekday)
                                }
                                
                            }
                            Spacer()
                            
                            Button {
                                isShowingCitySearch = true
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 30))
                                    .foregroundStyle(.black)
                            }

                        }
                        .padding(.horizontal, 20)
                        .frame(width: 350, height: 70)
                        
                    }
// MARK: -  Блок с баллами
                    ZStack {
                        MyRectangle(width: 350, height: 170)

                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Активность")

                                HStack(alignment: .bottom, spacing: 4) {
                                    Text("\(homeData?.activity ?? 0)")
                                        .font(.system(size: 100))
                                        //.foregroundStyle(Color(hex: allergenColor(value: homeData?.activity ?? 0)))
                                    Text("/ 10")
                                        .padding(.bottom, 25)
                                }
                            }

                            Spacer()

                            MiniRectangle(width: 170, height: 130, color: "f7f7f7")
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(width: 350, height: 170, alignment: .topLeading)
                    }
                    
/*
 // Заголосов с основными аллергенами
                    HStack {
                        Text("Основные аллегены:")
                            .font(.system(size: 18))
                    }
                    .frame(width: 310, alignment: .leading)
 */
// MARK: -  Блок с основными аллергенами
                    ZStack(alignment: .center) {
                        MyRectangle(width: 350, height: 210)
                        
                        VStack(alignment: .leading, spacing: 18) {
                            ForEach(homeData?.allergens ?? [], id: \.name) {allergen in
                                VStack(alignment: .leading, spacing: 6){
                                    HStack{
                                        Text(allergen.name)
                                        Spacer()
                                        ZStack{
                                            MiniRectangle(width: 37, height: 20, color: allergenColor(value: allergen.value))
                                            Text("\(allergen.value)/10")
                                                .font(.system(size: 13))
                                        }
                                    }
                                    .frame(width: 310, height: 30)
                                    
                                    ProgressView(value: Double(allergen.value), total: 10)
                                        .frame(width: 310)
                                        .tint(Color(hex: allergenColor(value: allergen.value)))
                                }
                            }
                        }
                    }
                    
// MARK: -  Блок как вы себя чувствуете
                    ZStack(alignment: .top) {
                        MyRectangle(width: 350, height: 170)
                        VStack(spacing: 15){
                            HStack{
                                Text("Как вы себя чувствуете?")
                                Spacer()
                                ZStack{
                                    MiniRectangle(width: 70, height: 30, color: "dcfcdc")
                                    HStack(spacing: 1){
                                        Image(systemName: "tree.circle.fill")
                                            .font(.system(size: 21))
                                        Text("+10")
                                            .foregroundStyle(Color(hex: "286127"))
                                    }
                                }
                            }
                            .frame(width: 310, height: 30)
                            HStack(spacing: 40){
                                feelButton(type: "Good")
                                feelButton(type: "Normal")
                                feelButton(type: "Bad")
                            }

                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.top, 15)
            }
            if showLocationPrompt {
                LocationPromptView {
                    // Это код выполнится, когда нажмут "Далее"
                    // Пока мы просто закрываем окно
                    showLocationPrompt = false
                }
                // Анимация плавного появления и исчезновения
                .transition(.opacity)
                .animation(.easeInOut, value: showLocationPrompt)
            }
        }
        // MARK: - Окно с городами
        .sheet(isPresented: $isShowingCitySearch) {
                    VStack {
                        Text("Тут будет список городов")
                            .font(.headline)
                    }
                    .presentationDetents([.medium, .large])
                }
        // MARK: - task,onChange
        .task(id: locationManager.location) {
            // 1. данные из UserDefaults
            if let loc = locationManager.location {
                print("location found")
                homeData = await loadHomeData(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
                print("data loaded")
            } else {
                // 2. запрос к GPS
                print("request to GPS...")
                locationManager.requestOneTimeLocation()
            }
        }
    }
}

// MARK: - Доп функции
struct DateText: View {
    let text: String
    var body: some View {
        Text("\(text)")
            .font(.system(size: 16))
    }
}
struct MyRectangle: View {
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: width, height: height)
            .foregroundStyle(Color(hex: "FFFFFF"))
    }
}

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

struct feelButton: View {
    let type: String
    var body: some View {
        Button {
            //
        } label: {
            if type == "Bad" {
                ZStack{
                    Image(systemName: "heart.badge.bolt.slash")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.red)
                
            }
            if type == "Normal"{
                
                ZStack{
                    Image(systemName: "bolt.heart")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.orange)
            }
            if type == "Good"{
                ZStack{
                    Image(systemName: "heart")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.green)
            }
            
        }
    }
}

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
