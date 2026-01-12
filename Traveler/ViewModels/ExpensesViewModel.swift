//
//  File.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//

import SwiftUI
import Foundation
internal import Combine

class ExpensesViewModel: ObservableObject {
    
    @Published var expenses: [ExpenseModel] = []
    
    let primaryColor = Color(red: 0.06, green: 0.27, blue: 0.39)
    
    var currencyCode: String {
        return Locale.current.currency?.identifier ?? "USD"
    }

    var currencyFormatter: FloatingPointFormatStyle<Double>.Currency {
        return .currency(code: currencyCode)
    }

    var netBalance: Double {
        totalLent - totalBorrowed
    }
    
    var totalLent: Double {
        expenses
            .filter { $0.movement == .lent }
            .reduce(0) { $0 + $1.amount }
    }
    var totalBorrowed: Double {
        expenses
            .filter { $0.movement == .borrowed }
            .reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double {
        netBalance
    }

    var individualBalances: [String: Double] {
        var balances = [String: Double]()
        let allParticipants = Set(expenses.map { $0.paidBy })
        
        for name in allParticipants {
            let lent = expenses.filter { $0.paidBy == name && $0.movement == .lent }.reduce(0) { $0 + $1.amount }
            let borrowed = expenses.filter { $0.paidBy == name && $0.movement == .borrowed }.reduce(0) { $0 + $1.amount }
            balances[name] = lent - borrowed
        }
        return balances
    }

    var balanceMessage: String {
        let formatter = currencyFormatter
        var message = ""
        
        for (person, amount) in individualBalances {
            if amount > 0 {
                message += "\(person) is owed \(abs(amount).formatted(formatter)).\n"
            } else if amount < 0 {
                message += "You owe \(person) \(abs(amount).formatted(formatter)).\n"
            } else {
                message += "\(person) is even.\n"
            }
        }
        return message.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
