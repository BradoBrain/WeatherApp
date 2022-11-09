//  Created by Artem Vinogradov

import SwiftUI

@main
struct DemoWeatherApp: App {
    /// Set up it as root view
    @StateObject var vm: WeatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
