//
//  Category.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//

import Foundation
enum Category: String, CaseIterable, Identifiable, Codable {
    case food = "Food"
    case transportation = "Transportation"
    case souvenirs = "Souvenirs"
    case lodging = "Lodging"
    case flights = "Flights"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transportation: return "car.fill"
        case .souvenirs: return "gift.fill"
        case .lodging: return "bed.double.fill"
        case .flights: return "airplane"
        }
    }
}
