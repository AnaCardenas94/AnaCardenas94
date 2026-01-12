//
//  WeatherViewModel.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 03/12/25.
//

import SwiftUI
import CoreLocation
internal import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var location: String = "Loading Location"
    @Published var weatherStatus: String = ""
    @Published var weatherIcon: String = ""

    private let weatherCodeMap: [Int: String] = [
        0: "Clear Sky",
        1: "Mainly Clear",
        2: "Partly Cloudy",
        3: "Overcast",
        45: "Fog",
        48: "Rime Fog",
        51: "Light Drizzle",
        53: "Drizzle",
        61: "Rain",
        80: "Light Rain Showers"
    ]
    
    private let weatherIconMap: [Int: String] = [
            0: "flaticon_sun",
            1: "flaticon_sun",
            2: "flaticon_partly_cloudy",
            3: "flaticon_overcast",
            45: "flaticon_fog",
            48: "flaticon_fog",
            51: "flaticon_drizzle",
            53: "flaticon_drizzle",
            61: "flaticon_rain",
            63: "flaticon_heavy_rain",
            80: "flaticon_rain_showers"
        ]
    
    func loadWeather(latitude: Double, longitude: Double) async {
        do {
            let weather = try await WeatherManager.shared.fetchWeather(
                latitude: latitude,
                longitude: longitude
            )
            
            temperature = weather.current_weather.temperature
            weatherStatus = weatherCodeMap[weather.current_weather.weathercode] ?? "Unknown"
            weatherIcon = weatherIconMap[weather.current_weather.weathercode] ?? ""
            
        } catch {
            location = "Error loading weather"
        }
    }
}
