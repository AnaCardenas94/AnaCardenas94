//
//  WeatherManager.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 03/12/25.
//

import Foundation

class WeatherManager {
    static let shared = WeatherManager()
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherResponse {
        let urlString = "\(APIConstants.baseURLWeather)\(latitude)&longitude=\(longitude)&current_weather=true"

        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
