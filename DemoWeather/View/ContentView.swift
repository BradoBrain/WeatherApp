//  Created by Artem Vinogradov

import SwiftUI

/**
ContentView supports two display options. Placeholdered View or View with data.
 
 - If there is no data or it is failed the View show us placeholder. Another case we get the View with current weather data. It made with:
 ```
 .redacted(reason: .placeholder)
 ```
 */

struct ContentView: View {
    @EnvironmentObject var vm: WeatherViewModel
    
    var body: some View {
        if vm.city == "No data" {
            WeatherView()
                .redacted(reason: .placeholder)
        } else {
            WeatherView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherViewModel())
    }
}
