//
//  Activity.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//
import SwiftData
import Foundation

@Model
class Activity {
    var date: Date
    var title: String
    var details: String
    var startTime: Date?
    var endTime: Date?
    var category: String?

    init(
        date: Date = Date(),
        title: String = "",
        details: String = "",
        startTime: Date? = nil,
        endTime: Date? = nil,
        category: String? = nil
    ) {
        self.date = date
        self.title = title
        self.details = details
        self.startTime = startTime
        self.endTime = endTime
        self.category = category
    }
}



