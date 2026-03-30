import Foundation
import CoreLocation
import Observation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    // Координаты, которые мы будем использовать в приложении
    var location: CLLocation?
    var isLoading = false
    var isDenied = false

    override init() {
        super.init()
        manager.delegate = self
        
        loadSavedLocation()
    }

    func requestOneTimeLocation() {
        if location != nil {
            return
        }
        
        isLoading = true
        let status = manager.authorizationStatus
        
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else {
            isDenied = true
            isLoading = false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            let status = manager.authorizationStatus
            print("status: \(status.rawValue)")
            
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                isDenied = false
                // Как только получили разрешение — сразу запрашиваем координаты
                manager.requestLocation()
            } else if status == .denied || status == .restricted {
                isDenied = true
                isLoading = false
            }
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        // 3. Сохраняем полученную локацию в память телефона
        saveLocationToMemory(lastLocation)
        
        self.location = lastLocation
        self.isLoading = false
    }

    // MARK: - Работа с памятью (UserDefaults)
    
    private func saveLocationToMemory(_ location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        UserDefaults.standard.set(lat, forKey: "saved_latitude")
        UserDefaults.standard.set(lon, forKey: "saved_longitude")
        print("saved: \(lat), \(lon)")
    }

    private func loadSavedLocation() {
        let lat = UserDefaults.standard.double(forKey: "saved_latitude")
        let lon = UserDefaults.standard.double(forKey: "saved_longitude")
        
        // Если lat и lon не равны 0 (UserDefaults возвращает 0, если данных нет)
        if lat != 0 && lon != 0 {
            self.location = CLLocation(latitude: lat, longitude: lon)
            print("unloading: \(lat), \(lon)")
        }
    }
    
    // Метод на случай, если мы захотим "забыть" город (например, при смене города вручную)
    func updateLocationManually(lat: Double, lon: Double) {
        let newLocation = CLLocation(latitude: lat, longitude: lon)
        saveLocationToMemory(newLocation)
        self.location = newLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("erreor GPS: \(error.localizedDescription)")
        isLoading = false
    }
}
