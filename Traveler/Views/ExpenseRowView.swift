//
//  ExpenseRowVie.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//

import SwiftUI

struct ExpenseRowView: View {

    var expense: ExpenseModel
    
    var body: some View {
        HStack {
            Image(systemName: expense.category.icon)
                .font(.title2)
                .foregroundColor(Color(red: 0.06, green: 0.27, blue: 0.39))
                .padding(.trailing, 6)
            
            VStack(alignment: .leading) {
                Text(expense.details)
                    .font(.headline)
                Text(expense.date, format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("$\(expense.amount, specifier: "%.2f")")
                    .bold()
                Text(expense.movement.rawValue)
                    .font(.caption2)
                    .foregroundColor(expense.movement.rawValue == MovementType.borrowed.rawValue ? Color(UIColor(red: 0.33, green: 0.69, blue: 0.55, alpha: 1.00)) : Color(UIColor(red: 0.93, green: 0.41, blue: 0.31, alpha: 1.00)))
            }
        }
    }
}
