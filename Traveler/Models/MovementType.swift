//
//  MovementType.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//

import Foundation
enum MovementType: String, CaseIterable, Identifiable, Codable {
    case lent = "Lent"
    case borrowed = "Borrowed"
    
    var id: String { rawValue }
}
