//  Created by Artem Vinogradov

import Foundation

/// Weather data from API response from https://openweathermap.org

struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

// MARK: - WeatherData properties extantion
extension WeatherData {

    /// Weather field in API
    struct Weather: Codable {
        let id: Int
        let weatherDescription: String

        enum CodingKeys: String, CodingKey {
            case id
            case weatherDescription = "description"
        }
    }

    ///  Main field in API
    struct Main: Codable {
        let temp, tempMin, tempMax: Double
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }

    /// Wind field in API
    struct Wind: Codable {
        let speed: Double
    }
}

