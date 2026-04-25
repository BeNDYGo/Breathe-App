import Foundation
import SwiftUI

// 1. Что отправляем
struct ChatRequest: Codable {
    let message: String
}

// 2. Что получаем
struct ChatResponse: Codable {
    let answer: String
}

// 3. Чистая функция запроса
func sendChatMessage(text: String) async -> String? {
    guard let url = URL(string: "\(baseURL)/chat") else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let body = ChatRequest(message: text)
    request.httpBody = try? JSONEncoder().encode(body)
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
        
        let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
        return decoded.answer
        
    } catch {
        print("Network error: \(error)")
        return nil
    }
}
