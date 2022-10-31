//
//  WeatherView.swift
//  DemoWeather
//
//  Created by Artem Vinogradov on 27.10.2022.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var vm: WeatherViewModel
    
    var body: some View {
        ZStack {
            // Backgroud of View. In future will be changed with custom pics
            LinearGradient(colors: [.mint, .blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            VStack {
                HStack {
                    // Button to get forecast in current location
                    Button {
                        vm.fetchWeatherFromCoordinates()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 55, height: 55)
                            
                            Image(systemName: "location")
                                .font(.title)
                        }
                    }
                    
                    // Search field to change a city for getting current weather forecast in this place
                    TextField("Search city", text: $vm.cityName)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .autocorrectionDisabled(true)
                        .frame(height: 55)
                        .keyboardType(.asciiCapable)
                        .onSubmit {
                            // To get current forecast in choosen city
                            vm.fetchWeatherFromCity()
                            
                            vm.cityName = ""
                        }
                        .submitLabel(.search)
                    
                    // To get current forecast in choosen city
                    Button {
                        vm.fetchWeatherFromCity()
                        
                        // To hide keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                        vm.cityName = ""
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 55, height: 55)
                            
                            Image(systemName: "location.magnifyingglass")
                                .font(.title)
                        }
                    }
                } .unredacted()
                
                // Current weather forecast data
                HStack {
                    Image(systemName: vm.iconName)
                    
                    Text(vm.currentTemp + "ºC")
                }
                .bold()
                .font(.system(size: 56))
                
                
                Text(vm.city)
                    .font(.largeTitle)
                
                Grid(horizontalSpacing: 40, verticalSpacing: 40) {
                    GridRow {
                        Image(systemName: "thermometer.low")
                        Text(vm.minTemp + " ºC")
                        
                        Image(systemName: "thermometer.high")
                        Text(vm.maxTemp + " ºC")
                    }
                    
                    GridRow {
                        Image(systemName: "humidity")
                        Text(vm.humidity + " %")
                        
                        Image(systemName: "wind")
                        Text(vm.windSpeed + " m/s")
                    }
                }
                .padding()
                .font(.title2)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                
                Spacer()
                
            }
            .padding()
            .foregroundColor(.white)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .environmentObject(WeatherViewModel())
    }
}
