//  Created by Artem Vinogradov

import Foundation
import Combine
import CoreLocation

/// Class that contains publishers for search text field, WeatherData, computed properties for WeatherView and final methods to get WeatherData with city name and user's coordinates

class WeatherViewModel: NSObject, ObservableObject {
    /// Publisher to observe text field value for method fetchWeatherFromCity()
    @Published var cityName = ""
    /// Publisher to observe new data for WeatherData
    @Published var weatherData: WeatherData?
    
    var cancellables: Set<AnyCancellable> = []
    
    /// Object instance to start and stop the delivery of location-related
    var locationManager = CLLocationManager()
    
    /// Computed property to get name of city to display on WeatherView
    var city: String { weatherData?.name ?? "No data" }
    /// Computed property to get value of current temperature
    var currentTemp: String { String(format: "%.0f", weatherData?.main.temp ?? 0.0) }
    /// Computed property to get minimum value of temperature current day
    var minTemp: String { String(format: "%.1f", weatherData?.main.tempMin ?? 0.0) }
    /// Computed property to get maximum value of temperature current day
    var maxTemp: String { String(format: "%.1f", weatherData?.main.tempMax ?? 0.0) }
    /// Computed property to get value of humidity level
    var humidity: String { String(weatherData?.main.humidity ?? 0) }
    /// Computed property to get value of wind speed
    var windSpeed: String { String(format: "%.1f", weatherData?.wind.speed ?? 0.0) }
    /// Computed property to get  icon name
    var iconName: String {
        guard let description = weatherData?.weather[0].weatherDescription else { return "exclamationmark.arrow.triangle.2.circlepath" }
        switch description {
        case "clear sky": return "sun.min"
        case "few clouds": return "cloud.sun"
        case "scattered clouds": return "cloud"
        case "broken clouds", "overcast clouds": return "smoke"
        case "moderate rain", "heavy intensity rain", "very heavy rain", "extreme rain": return "cloud.sun.rain"
        case "freezing rain": return "cloud.sleet"
        case "shower rain", "light intensity shower rain", "heavy intensity shower rain", "ragged shower rain": return "cloud.heavyrain"
        case "light intensity drizzle", "drizzle", "heavy intensity drizzle", "light intensity drizzle rain", "drizzle rain", "heavy intensity drizzle rain ", "shower rain and drizzle", "heavy shower rain and drizzle", "shower drizzle": return "cloud.drizzle"
        case "thunderstorm with light rain", "thunderstorm with rain", "thunderstorm with heavy rain", "light thunderstorm", "thunderstorm", "heavy thunderstorm", "ragged thunderstorm", "thunderstorm with light drizzle", "thunderstorm with drizzle", "thunderstorm with heavy drizzle": return "cloud.bolt.rain"
        case "snow", "light snow", "Heavy snow", "Sleet", "Light shower sleet", "Shower sleet", "Light rain and snow", "Rain and snow", "Light shower snow", "Shower snow", "Heavy shower snow": return "cloud.snow"
        case "mist", "Smoke", "Haze", "sand/ dust whirl", "fog", "sand", "dust", "volcanic ash", "squalls": return "aqi.low"
        case "tornado": return "tornado"
        default: return "questionmark.circle"
        }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization() // To ask the user for permission to use the user's current location
        locationManager.requestLocation()
    }
    
    /// Method to get current forecast with city name and set it to AnyCancellable
    func fetchWeatherFromCity() {
        
        NetworkManager().getWeatherFromCity(cityName: cityName.replacingOccurrences(of: " ", with: "+")) // using .replacingOccurrences to get rid of whitespace into URL
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: {[weak self] weatherData in
                self?.weatherData = weatherData
            }
            .store(in: &cancellables)
    }
}

//MARK: - CLLocationManagerDelegate section

extension WeatherViewModel: CLLocationManagerDelegate {
    /// Method to get current forecast with user's coordinates and set it to AnyCancellable
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            /// Method to get current forecast with city name and set it to AnyCancellable
            NetworkManager().getWeatherFromCoordinates(latitude: lat, longitude: lon)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error.localizedDescription)
                    }
                } receiveValue: {[weak self] weatherData in
                    self?.weatherData = weatherData
                }
                .store(in: &cancellables)
        }
    }
    
    /// Method to get error description when didn't get coordinates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("It was error during getting coordinates: \(error.localizedDescription)")
    }
}
