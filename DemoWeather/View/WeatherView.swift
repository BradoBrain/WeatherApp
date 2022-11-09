//  Created by Artem Vinogradov

import SwiftUI

/**
 WeatherView is a place where main UI has built. It made for ContentView.
 
 Here are description of UI section:
 - Background section contains background pic.
 - Search/User location section contains:
 - UserCurrentLocation button to get current user location.
 - SearchTextField to text city name for getting current forecast in this place.
 - CustomCityNameForecast button to get forecast for city from SearchTextField.
 - CurrentWeatherForcastData section contains:
 - Current weather icon and temperature in ºC.
 - Current city name.
 - Current min/max temperatures, humidity level and speed of wind.
 */

struct WeatherView: View {
    @EnvironmentObject var vm: WeatherViewModel
    
    var body: some View {
        ZStack {
            //MARK: - Background section
            LinearGradient(colors: [.mint, .blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            VStack {
                
                //MARK: - Search/User location section
                HStack {
                    /// UserCurrentLocation button
                    Button { vm.locationManager.requestLocation() } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 55, height: 55)
                            
                            Image(systemName: "location")
                                .font(.title)
                        }
                    }
                    
                    /// SearchTextField
                    TextField("Search city", text: $vm.cityName)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .autocorrectionDisabled(true)
                        .frame(height: 55)
                        .keyboardType(.asciiCapable)
                        .onSubmit {
                            vm.fetchWeatherFromCity() // To get current forecast in choosen city
                            vm.cityName = "" // Makes search field clear after keyboard return button was pressed
                        }
                        .submitLabel(.search) // Change keyboard return button lable
                    
                    /// CustomCityNameForecast
                    Button {
                        vm.fetchWeatherFromCity() // To get current forecast for city from SearchTextField
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // To hide keyboard
                        vm.cityName = "" // Makes search field clear after keyboard return button was pressed
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.ultraThinMaterial)
                                .frame(width: 55, height: 55)
                            
                            Image(systemName: "location.magnifyingglass")
                                .font(.title)
                        }
                    }
                } .unredacted() // To make this section visible all time
                
                //MARK: - CurrentWeatherForcastData section
                
                /// Current weather icon and temperature in ºC
                HStack {
                    Image(systemName: vm.iconName)
                    
                    Text(vm.currentTemp + "ºC")
                }
                .bold()
                .font(.system(size: 56))
                
                /// Current city name
                Text(vm.city)
                    .font(.largeTitle)
                
                /// Current min/max temperatures, humidity level and speed of wind
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
