//
//  EmailValidator.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 20/11/25.
//

import Foundation

struct EmailValidator {
    static func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", regex)
        return predicate.evaluate(with: email)
    }
}
