//
//  NetworkingManager.swift
//  DemoWeather
//
//  Created by Artem Vinogradov on 27.10.2022.
//

import Foundation
import Combine
import CoreLocation

class NetworkingManager: ObservableObject {
    
    func getWeatherFromCity(cityName: String) -> AnyPublisher<WeatherModel, Error> {
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
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getWeatherFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> AnyPublisher<WeatherModel, Error> {
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
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
