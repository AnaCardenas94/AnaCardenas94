//
//  User.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 20/11/25.
//
import SwiftData
import Foundation

@Model
class User {
    var email: String
    var nombreCompleto: String
    var password: String
    var foto: Data?

    init(email: String,
         nombreCompleto: String,
         password: String,
         foto: Data? = nil) {
        
        self.email = email
        self.nombreCompleto = nombreCompleto
        self.password = password
        self.foto = foto
    }
}
