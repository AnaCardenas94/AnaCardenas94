//
//  ExchangeAPIManager.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 24/11/25.
//
import Foundation

class ExchangeAPIManager {
    static let shared = ExchangeAPIManager()

    func convert(from: String, to: String, amount: Double) async throws -> Double {
        let url = URL(string: "\(APIConstants.baseURL)/\(from)")!
        let data = try await URLSession.shared.data(from: url).0
        
        let decoded = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
        let rate = decoded.rates[to] ?? 0
        return rate * amount
    }

    func getHistory(from: String, to: String) async throws -> [RateData] {
        // Esta API no trae histórico, así que generamos uno simulado basado en el último valor
        let url = URL(string: "\(APIConstants.baseURL)/\(from)")!
        let data = try await URLSession.shared.data(from: url).0
        
        let decoded = try JSONDecoder().decode(ExchangeRatesResponse.self, from: data)
        let baseRate = decoded.rates[to] ?? 0

        return (0..<7).map { i in
            RateData(day: "Día \(i+1)", rate: baseRate * (1 + Double.random(in: -0.02...0.02)))
        }
    }
}

