import Foundation

func sendFeelingReport(lat: Double, lon: Double, score: Int) async {
    let url = URL(string: "http://192.168.x.x:8750/feeling")! // ЗАМЕНИ НА СВОЙ IP / ДОМЕН
    
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
