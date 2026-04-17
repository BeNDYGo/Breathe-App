import Foundation
import CoreLocation
import Observation
import MapKit

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    var cityName: String = "Город"
    var location: CLLocationCoordinate2D?
    var authStatus: CLAuthorizationStatus

    override init() {
        self.authStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        
        loadSavedLocation() // Проверяем, есть ли старые сохранения
    }

    // 1. Метод вызова системного окна (вызовем его после нашей красивой кнопки "Далее")
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    // 2. Метод разового запроса координат (вызывается только если разрешение уже есть)
    func fetchLocation() {
        manager.requestLocation()
    }

    // MARK: - Делегаты (Ответы от системы)
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authStatus = manager.authorizationStatus // Обновляем статус для интерфейса
        
        // Если пользователь только что нажал "Разрешить", сразу просим координаты
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
            fetchLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        guard let lastLocation = locations.last else { return }
        self.location = lastLocation.coordinate
        
        fetchCityName(from: lastLocation.coordinate)
        
        // Сохраняем, чтобы не дергать GPS при следующем запуске
        UserDefaults.standard.set(lastLocation.coordinate.latitude, forKey: "saved_lat")
        UserDefaults.standard.set(lastLocation.coordinate.longitude, forKey: "saved_lon")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка GPS: \(error.localizedDescription)")
    }

    // MARK: Метод для ручной установки города из поиска
    func setManualLocation(coordinate: CLLocationCoordinate2D, name: String) {
        self.location = coordinate
        self.cityName = name // Сразу ставим красивое имя без всяких геокодеров
        
        // Сохраняем в память и координаты, и ТЕКСТ
        UserDefaults.standard.set(coordinate.latitude, forKey: "saved_lat")
        UserDefaults.standard.set(coordinate.longitude, forKey: "saved_lon")
        UserDefaults.standard.set(name, forKey: "saved_city_name")
    }
// MARK: - Загрузка из памяти
    private func loadSavedLocation() {
        let lat = UserDefaults.standard.double(forKey: "saved_lat")
        let lon = UserDefaults.standard.double(forKey: "saved_lon")
        let savedName = UserDefaults.standard.string(forKey: "saved_city_name") // Достаем текст
        
        if lat != 0 && lon != 0 {
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            if let name = savedName {
                self.cityName = name // Берем из памяти (например "Москва")
            } else {
                fetchCityName(from: self.location!) // Только на крайний случай
            }
        }
    }
    private func fetchCityName(from coordinate: CLLocationCoordinate2D) {
        // 1. Создаем объект CLLocation
        let clLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // 2. Передаем в параметр location:
        guard let request = MKReverseGeocodingRequest(location: clLocation) else { return }
        
        Task {
            do {
                // 3. Получаем массив MKMapItem
                let items = try await request.mapItems
                
                // 4. Достаем placemark из первого элемента
                if let placemark = items.first?.placemark {
                    let city = placemark.locality ?? placemark.administrativeArea ?? "Ваш город"
                    
                    await MainActor.run {
                        self.cityName = city
                        UserDefaults.standard.set(city, forKey: "saved_city_name")
                    }
                }
            } catch {
                print("Ошибка геокодинга: \(error.localizedDescription)")
            }
        }
    }


}
