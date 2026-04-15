import Foundation

// Модели данных
struct Stats: Decodable {
    let count: Int
    let avg: Double
}

struct ProData: Decodable {
    let activity: Double
    let weatherHourly10: [Double]
    let weatherIconsHourly10: [String]
    let precipitationProbabilityHourly10: [Int]
    let humidityHourly10: [Int]
    let windHourly10: [Double]
    let communityReports: Stats
}

// Функция загрузки
func loadProData(lat: Double, lon: Double) async -> ProData? {
    guard var components = URLComponents(string: "\(baseURL)/proView") else { return nil }
    components.queryItems = [
        URLQueryItem(name: "lat", value: String(lat)),
        URLQueryItem(name: "lon", value: String(lon))
    ]

    guard let url = components.url else { return nil }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ProData.self, from: data)
    } catch {
        print("Ошибка загрузки Pro данных: \(error.localizedDescription)")
        return nil
    }
}

