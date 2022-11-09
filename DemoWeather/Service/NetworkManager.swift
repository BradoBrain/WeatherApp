//  Created by Artem Vinogradov

import Foundation
import Combine
import CoreLocation

/**
 NetworkManager is class that contains two methods (getWeatherFromCity() and getWeatherFromCoordinates()) to get current weather forecast with name of city or current user coordinates.
 
 - Method getWeatherFromCity has one parameter:
 ```
 cityName: String
 ```
 - Method getWeatherFromCoordinates has two parameters:
 ```
 latitude: CLLocationDegrees
 longitude: CLLocationDegrees
 ```
 
 > Description:
 Both methods use URLSession with .dataTaskPublisher(for: URL) and return AnyPublisher. It will be with decoded data when response is 200 or error when it get bad response.
 */

class NetworkManager: ObservableObject {
    /// Method to get current weather forecast with city name
    func getWeatherFromCity(cityName: String) -> AnyPublisher<WeatherData, Error> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?&appid=\(StaticData.apiKey)&units=metric&q=\(cityName)") else {
            fatalError("Bad URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    /// Method to get current weather forecast with current user's location
    func getWeatherFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> AnyPublisher<WeatherData, Error> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(StaticData.apiKey)&units=metric") else {
            fatalError("Bad URL")
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
