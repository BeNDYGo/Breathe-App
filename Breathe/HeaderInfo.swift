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
    let city: String?
    let activity: Int
    let allergens: [Allergen]
    let weatherImage: String
}

struct Allergen: Decodable {
    let name: String
    let value: Int
}

func loadHomeData(lat: Double, lon: Double) async -> HeadActivity? {
    guard var url = URL(string: "http://127.0.0.1:8750/homeView") else {
        return nil
    }
    
    url.append(queryItems:[
        URLQueryItem(name: "lat", value: String(lat)),
        URLQueryItem(name: "lon", value: String(lon))
    ])
    
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("Ошибка сервера: \(httpResponse.statusCode)")
        }
        
        let decoded = try JSONDecoder().decode(HeadActivity.self, from: data)
        return decoded
        
    } catch {
        print("Ошибка загрузки: \(error.localizedDescription)")
        return nil
    }
}

func allergenColor(value: Int) -> String {
    switch value {
    case 0...3:
        return "e9fa93"
    case 4...8:
        return "ffe6a8"
    default:
        return "fa9393"
    }
}
