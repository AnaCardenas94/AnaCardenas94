//
//  Expense.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 26/11/25.
//

import SwiftData
import SwiftUI

@Model
class ExpenseModel {

    var category: Category
    var details: String
    var amount: Double
    var paidBy: String
    var date: Date
    var movement: MovementType
    var receiptImageData: Data?

    init(category: Category,
         details: String,
         amount: Double,
         paidBy: String,
         date: Date,
         movement: MovementType,
         receiptImage: UIImage? = nil) {

        self.category = category
        self.details = details
        self.amount = amount
        self.paidBy = paidBy
        self.date = date
        self.movement = movement

        if let image = receiptImage {
            self.receiptImageData = image.jpegData(compressionQuality: 0.8)
        }
    }

    var receiptImage: UIImage? {
        if let receiptImageData {
            return UIImage(data: receiptImageData)
        }
        return nil
    }
}

