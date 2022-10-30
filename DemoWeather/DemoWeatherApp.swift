//
//  DemoWeatherApp.swift
//  DemoWeather
//
//  Created by Artem Vinogradov on 27.10.2022.
//

import SwiftUI

@main
struct DemoWeatherApp: App {
    @StateObject var vm: WeatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
