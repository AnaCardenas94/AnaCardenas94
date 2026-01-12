//
//  CalendarMonthGridView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//

import SwiftUI
struct CalendarMonthGridview: View {

    @Binding var selectedDate: Date?

    let highlightColor: Color
    let rangeOfTravel: ClosedRange<Date>
    let monthStart: Date

    private let cal = Calendar.current

    var body: some View {

        let grid = cal.generateCalendarGrid(for: monthStart)
        let normalizedRange = normalize(rangeOfTravel)
        let normalizedSelected = selectedDate.map { cal.startOfDay(for: $0) }
        LazyVGrid(
            columns: Array(repeating: .init(.flexible()), count: 7),
            spacing: 12
        ) {
            ForEach(Array(grid.enumerated()), id: \.offset) { _, day in
                if let day = day {
                    let dayNormalized = cal.startOfDay(for: day)
                    let isSelectable = normalizedRange.contains(dayNormalized)
                    let isSelected = normalizedSelected == dayNormalized
                    let isInTripRange = normalizedRange.contains(dayNormalized)

                    VStack(spacing: 4) {
                        Text("\(cal.component(.day, from: day))")
                            .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                            .foregroundColor(isSelected ? .white :
                                (isSelectable ? .primary : .secondary.opacity(0.6))
                            )
                            .frame(width: 36, height: 36)
                            .background(
                                Circle()
                                    .fill((isSelected && isSelectable) ? highlightColor : Color.clear) 
                            )
                            .onTapGesture {
                                if isSelectable {
                                    selectedDate = dayNormalized
                                }
                            }
                            .opacity(isSelectable ? 1 : 0.35)

                        Circle()
                            .fill(isInTripRange ? highlightColor.opacity(0.55) : Color.clear) // 👈 antes mainColor
                            .frame(width: 6, height: 6)
                    }
                    .frame(maxWidth: .infinity, minHeight: 40)

                } else {
                    Color.clear.frame(maxWidth: .infinity, minHeight: 40)
                }
            }
        }
        .padding(.vertical, 6)
    }

    private func normalize(_ range: ClosedRange<Date>) -> ClosedRange<Date> {
        let lower = cal.startOfDay(for: range.lowerBound)
        let upper = cal.startOfDay(for: range.upperBound)
        return min(lower, upper)...max(lower, upper)
    }
}
