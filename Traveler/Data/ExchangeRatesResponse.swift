//
//  ExchangeRatesResponse.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 24/11/25.
//

import Foundation

struct ExchangeRatesResponse: Decodable {
    let result: String
    let base_code: String
    let rates: [String: Double]
}
