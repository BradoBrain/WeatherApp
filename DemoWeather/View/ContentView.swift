//
//  ContentView.swift
//  DemoWeather
//
//  Created by Artem Vinogradov on 27.10.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: WeatherViewModel
    
    var body: some View {
        if vm.city == "No data" {
            WeatherView()
                .redacted(reason: .placeholder) // To get placeholdered View when we don't get data
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
