import Foundation
import MapKit
import Observation

@Observable
class CitySearchViewModel: NSObject, MKLocalSearchCompleterDelegate {
    var searchQuery = ""
    var results: [MKLocalSearchCompletion] = []
    
    // Специальный инструмент Apple для автодополнения адресов
    private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = .address // Ищем только адреса/города, а не кафе и магазины
    }

    // Вызываем каждый раз, когда меняется текст в поиске
    func search(query: String) {
        if query.isEmpty {
            results = []
        } else {
            completer.queryFragment = query
        }
    }

    // МАРК: - Делегат (Срабатывает, когда Apple присылает подсказки)
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Оставляем только те результаты, где нет цифр (чтобы исключить конкретные улицы/дома, оставив города)
        self.results = completer.results.filter { result in
            !result.title.contains(where: { $0.isNumber })
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Ошибка автодополнения: \(error.localizedDescription)")
    }
}
