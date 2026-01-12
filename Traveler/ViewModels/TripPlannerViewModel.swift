//
//  TripPlannerViewModel.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//
import Foundation
import SwiftUI
import SwiftData
internal import Combine

@MainActor
final class TripPlannerViewModel: ObservableObject {

    @Published var selectedDate: Date? = nil
    @Published var activities: [Activity] = []
    @Published var errorMessage: String? = nil

    let primaryColor = Color(red: 0.06, green: 0.27, blue: 0.39)

    init() { }

    func activities(for date: Date) -> [Activity] {
        let calendar = Calendar.current
        _ = calendar.startOfDay(for: date)
        let filteredList = activities
            .filter { activity in
                let isSameDay = calendar.isDate(activity.date, equalTo: date, toGranularity: .day)
                
                print("Actividad: \(activity.title) (\(activity.date)) -> Coincide: \(isSameDay)")
                
                return isSameDay
            }
            .sorted { $0.startTime ?? Date.distantPast < $1.startTime ?? Date.distantPast }
        return filteredList
    }
}
