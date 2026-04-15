import Foundation
import SwiftUI


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

struct HeaderInfo {
    let currentDate = Date()
    let formatter = DateFormatter()
    
    
    var dayNumber: String {
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d"
        return formatter.string(from: currentDate)
    }

    var weekday: String {
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: currentDate).capitalized
    }
}

struct HeadActivity: Decodable {
    let activity: Int
    let allergens: [Allergen]
    let weather: HomeWeather?
    let serverInfo: String?
}

struct HomeWeather: Decodable {
    let temperature: Double
    let wind_speed: Double
    let icon: String
}


struct Allergen: Decodable {
    let name: String
    let value: Int
    let img: String
}

func loadHomeData(lat: Double, lon: Double) async -> HeadActivity? {
    guard var components = URLComponents(string: "\(baseURL)/homeView") else {
        return nil
    }

    components.queryItems = [
        URLQueryItem(name: "lat", value: String(lat)),
        URLQueryItem(name: "lon", value: String(lon))
    ]

    guard let url = components.url else { return nil }

    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        return try JSONDecoder().decode(HeadActivity.self, from: data)
    } catch {
        print("Ошибка загрузки: \(error.localizedDescription)")
        return nil
    }
}


