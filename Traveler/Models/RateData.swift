//
//  RateData.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//

import Foundation
struct RateData: Identifiable, Decodable {
    var id: String { day }
    let day: String
    let rate: Double
}
