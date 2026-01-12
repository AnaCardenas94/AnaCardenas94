//
//  WeatherResponse.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 03/12/25.
//

import Foundation

struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Double
    let current_weather_units: CurrentWeatherUnits
    let current_weather: CurrentWeather
}

struct CurrentWeatherUnits: Codable {
    let time: String
    let interval: String
    let temperature: String
    let windspeed: String
    let winddirection: String
    let is_day: String
    let weathercode: String
}

struct CurrentWeather: Codable {
    let time: String
    let interval: Int
    let temperature: Double
    let windspeed: Double
    let winddirection: Int
    let is_day: Int
    let weathercode: Int
}

