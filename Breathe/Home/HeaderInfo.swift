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
    let weatherImage: String
    let server_info: String?
}


struct Allergen: Decodable {
    let name: String
    let value: Int
}

struct urlServ: Decodable {
    let url: String
}

func getUrlServerFromGithub() async -> String? {
    guard let url = URL(string: "https://bendygo.github.io/BeNDYGo-API/Breathe-App-Backend.json") else {
        return nil
    }

    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            return nil
        }

        let decoded = try JSONDecoder().decode(urlServ.self, from: data)
        return decoded.url
    } catch {
        print("Ошибка URL: \(error.localizedDescription)")
        return nil
    }
}

func loadHomeData(lat: Double, lon: Double) async -> HeadActivity? {
    guard let baseURL = await getUrlServerFromGithub() else {
        return nil
    }

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
