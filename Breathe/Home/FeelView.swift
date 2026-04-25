import SwiftUI
import CoreLocation

// MARK: - Главный блок FeelView
struct FeelView: View {
    var locationManager: LocationManager
    @Binding var homeData: HeadActivity?
    
    @AppStorage("lastFeelingSubmitTime") private var lastSubmissionTime: Double = 0
    
    var isLocked: Bool {
        let currentTime = Date().timeIntervalSince1970
        return (currentTime - lastSubmissionTime) < 3600
    }

    var body: some View {
        ZStack(alignment: .center) {
            MyRectangle(width: 350, height: 170)
            
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "blood.pressure.cuff.fill")
                        .foregroundStyle(.orange)
                    
                    Text("Как вы себя чувствуете?")
                        .foregroundStyle(Color(hex: "37475a"))
                    
                    Spacer()
                    
                    ZStack {
                        MiniRectangle(width: 70, height: 30, color: "dcfcdc")
                        HStack(spacing: 1) {
                            Image(systemName: "sparkles.2")
                                .font(.system(size: 21))
                                .foregroundStyle(.black)
                            Text("+1")
                                .foregroundStyle(Color(hex: "286127"))
                        }
                    }
                }
                .frame(width: 310) // Ограничиваем ширину контента внутри белого фона
                
                // РАЗВИЛКА С АНИМАЦИЕЙ
                if isLocked {
                    // Плашка-заглушка
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.green)
                        
                        Text("Ваша оценка учтена")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color(hex: "37475a"))
                    }
                    .frame(width: 310, height: 70)
                    .background(Color(hex: "f9f7ed"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .transition(.scale.combined(with: .opacity))
                    
                } else {
                    // Кнопки
                    HStack(spacing: 40) {
                        feelButton(type: "Good", locationManager: locationManager, homeData: $homeData) { lockButtons() }
                        feelButton(type: "Normal", locationManager: locationManager, homeData: $homeData) { lockButtons() }
                        feelButton(type: "Bad", locationManager: locationManager, homeData: $homeData) { lockButtons() }
                    }
                    .padding(.top, 5)
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        // Анимация упругого "прыжка" при переключении
        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isLocked)
    }
    
    private func lockButtons() {
        lastSubmissionTime = Date().timeIntervalSince1970
    }
}

// MARK: - Сама кнопка
struct feelButton: View {
    let type: String
    var locationManager: LocationManager
    @Binding var homeData: HeadActivity?
    
    // Добавляем замыкание (инструкцию), которая сработает после клика
    var onSubmit: () -> Void

    var body: some View {
        Button {
            if let loc = locationManager.location {
                Task {
                    var score = 1
                    if type == "Normal" { score = 2 }
                    else if type == "Bad" { score = 3 }
                    
                    // 1. Отправляем на сервер
                    await sendFeelingReport(lat: loc.latitude, lon: loc.longitude, score: score)
                    
                    // 2. Перезапрашиваем данные
                    homeData = await loadHomeData(lat: loc.latitude, lon: loc.longitude)
                    
                    // 3. Блокируем кнопки (меняем интерфейс)
                    // Используем MainActor, так как UI должен обновляться в главном потоке
                    await MainActor.run {
                        onSubmit()
                    }
                }
            }
        } label: {
            if type == "Bad" {
                ZStack {
                    Image(systemName: "heart.badge.bolt.slash")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.red)
            }
            if type == "Normal" {
                ZStack {
                    Image(systemName: "bolt.heart")
                        .font(.system(size: 35))
                }
                .frame(width: 40, height: 40)
                .padding(20)
                .background(Color(hex: "f7f7f7"))
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .foregroundStyle(.orange)
            }
            if type == "Good" {
                ZStack {
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

func sendFeelingReport(lat: Double, lon: Double, score: Int) async {
    let url = URL(string: baseURL + "/feeling")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Упаковываем данные в JSON
    let body: [String: Any] = [
        "lat": lat,
        "lon": lon,
        "score": score
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            print("Самочувствие отправлено! (Оценка: \(score))")
        } else {
            print("Ошибка отправки на сервер")
        }
    } catch {
        print("Ошибка сети: \(error.localizedDescription)")
    }
}
