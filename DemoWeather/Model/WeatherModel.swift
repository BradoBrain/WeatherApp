//
//  WeatherModel.swift
//  DemoWeather
//
//  Created by Artem Vinogradov on 27.10.2022.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let weatherDescription: String

    enum CodingKeys: String, CodingKey {
        case id
        case weatherDescription = "description"
    }
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case  humidity
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
}
