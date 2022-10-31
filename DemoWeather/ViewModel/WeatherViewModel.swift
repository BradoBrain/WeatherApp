//
//  WeatherViewModel.swift
//  DemoWeather
//
//  Created by Artem Vinogradov on 27.10.2022.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var cityName = ""
    @Published var weatherData: WeatherModel?
    
    var cancellables: Set<AnyCancellable> = []
    
    let locationManager = LocationManager()
    
    // Computed properties for WeatherView
    var city: String { weatherData?.name ?? "No data" }
    var currentTemp: String { String(format: "%.0f", weatherData?.main.temp ?? 0.0) }
    var minTemp: String { String(format: "%.1f", weatherData?.main.tempMin ?? 0.0) }
    var maxTemp: String { String(format: "%.1f", weatherData?.main.tempMax ?? 0.0) }
    var humidity: String { String(weatherData?.main.humidity ?? 0) }
    var windSpeed: String { String(format: "%.1f", weatherData?.wind.speed ?? 0.0) }
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
    
    init() {
        locationManager.requestLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.fetchWeatherFromCoordinates()
        }
    }
    
    // Methods to fetch Weather
    
    // with cityName
    func fetchWeatherFromCity() {
        // using .replacingOccurrences to get rid of whitespace into URL
        NetworkManager().getWeatherFromCity(cityName: cityName.replacingOccurrences(of: " ", with: "+"))
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
    
    // with coordinates from locationManager
    func fetchWeatherFromCoordinates() {
        if let location = locationManager.location {
            
        NetworkManager().getWeatherFromCoordinates(latitude: location.latitude, longitude: location.longitude)
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
}
