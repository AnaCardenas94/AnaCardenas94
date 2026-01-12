//
//  ExchangeViewModel.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 24/11/25.
//

import Foundation
internal import Combine

@MainActor
final class ExchangeViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var from = "MXN"
    @Published var to = "USD"
    @Published var amount: Double = 1
    @Published var result: (Double,Error?) = (0,nil)
    @Published var history: [RateData] = []
    
    init() {
        currencies = [
            Currency(code: "USD", name: "Dólar estadounidense", flag: "🇺🇸"),
            Currency(code: "EUR", name: "Euro", flag: "🇪🇺"),
            Currency(code: "MXN", name: "Peso mexicano", flag: "🇲🇽"),
            Currency(code: "JPY", name: "Yen japonés", flag: "🇯🇵"),
            Currency(code: "KRW", name: "Won surcoreano", flag: "🇰🇷")
        ]

        if let fromCurrency = UserDefaults.standard.string(forKey: "defaultFrom") {
            from = fromCurrency
        }
        
        if let toCurrency = UserDefaults.standard.string(forKey: "defaultTo") {
            from = toCurrency
        }
        
        if let defaultAmount = UserDefaults.standard.string(forKey: "defaultAmount") {
            amount = Double(defaultAmount) ?? 1
        }
    }

    func convert() async {
        do {
            let value = try await ExchangeAPIManager.shared.convert(from: from, to: to, amount: amount)
            result = (value,nil)
            history = try await ExchangeAPIManager.shared.getHistory(from: from, to: to)
        } catch {
            result = (0,error)
            print("Error: \(error)")
        }
    }
}
