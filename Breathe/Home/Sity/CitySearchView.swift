import SwiftUI
import MapKit

struct CitySearchView: View {
    // Эта переменная позволяет шторке закрыть саму себя
    @Environment(\.dismiss) var dismiss
    
    @State private var viewModel = CitySearchViewModel()
    
    // Это "событие", которое мы передадим обратно в HomeView при клике на город
    var onCitySelected: (CLLocationCoordinate2D, String) -> Void

    var body: some View {
        NavigationStack {
            List(viewModel.results, id: \.self) { result in
                VStack(alignment: .leading) {
                    Text(result.title) // Название города (напр. "Москва")
                        .font(.system(size: 16, weight: .medium))
                    Text(result.subtitle) // Подпись (напр. "Россия")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
                // Делаем строку кликабельной (чтобы не было серого выделения как в обычных кнопках)
                .contentShape(Rectangle())
                .onTapGesture {
                    fetchCoordinates(for: result)
                }
            }
            .listStyle(.plain) // Убираем серый фон списка
            .navigationTitle("Поиск города")
            .navigationBarTitleDisplayMode(.inline)
            
            // Встроенная в iOS строка поиска
            .searchable(text: $viewModel.searchQuery, prompt: "Введите название...")
            // Следим за тем, что вводит пользователь
            .onChange(of: viewModel.searchQuery) { _, newValue in
                viewModel.search(query: newValue)
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Отмена") { dismiss() }
                }
            }
        }
    }

    // МАРК: - Превращаем текстовый ответ в координаты
    private func fetchCoordinates(for completion: MKLocalSearchCompletion) {
        // Подсказки дают только текст. Чтобы получить GPS-координаты города, делаем быстрый скрытый запрос
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        
        // Используем современный Task для асинхронного запроса (iOS 15+)
        Task {
            do {
                let response = try await search.start()
                if let coordinate = response.mapItems.first?.location.coordinate {
                    
                    // Передаем координаты обратно в HomeView
                    onCitySelected(coordinate, completion.title)
                    
                    // Плавно закрываем шторку
                    dismiss()
                }
            } catch {
                print("Не удалось получить координаты: \(error.localizedDescription)")
            }
        }
    }
}
