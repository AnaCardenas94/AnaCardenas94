//
//  Calendar.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//

import Foundation

extension Calendar {

    func generateDates(between start: Date, and end: Date) -> [Date] {
        let startDay = startOfDay(for: start)
        let endDay = startOfDay(for: end)

        guard startDay <= endDay else { return [] }

        var dates: [Date] = []
        var current = startDay

        while current <= endDay {
            dates.append(current)
            guard let next = date(byAdding: .day, value: 1, to: current) else { break }
            current = next
        }

        return dates
    }
    
    func generateMonthsBetween(start: Date, end: Date) -> [Date] {
        var months: [Date] = []
        var current = date(from: dateComponents([.year, .month], from: start))!

        while current <= end {
            months.append(current)
            current = date(byAdding: .month, value: 1, to: current)!
        }

        return months
    }

    func generateCalendarGrid(for month: Date) -> [Date?] {
        var grid: [Date?] = []
        guard let firstDay = date(from: dateComponents([.year, .month], from: month)),
              let range = range(of: .day, in: .month, for: month) else { return [] }

        let weekday = component(.weekday, from: firstDay)
        let offset = (weekday + 5) % 7
        grid.append(contentsOf: Array(repeating: nil, count: offset))

        for day in 1...range.count {
            grid.append(date(byAdding: .day, value: day - 1, to: firstDay))
        }

        while grid.count % 7 != 0 { grid.append(nil) }

        return grid
    }
}
