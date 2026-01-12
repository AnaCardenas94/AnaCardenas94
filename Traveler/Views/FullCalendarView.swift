//
//  FullCalendarView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//

import SwiftUI

struct FullCalendarView: View {

    @Binding var selectedDate: Date?
    
    let highlightColor: Color
    let start: Date
    let end: Date

    var body: some View {
        let months = Calendar.current.generateMonthsBetween(start: start, end: end)

        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(months, id: \.self) { (monthStart: Date) in
                    VStack(alignment: .leading, spacing: 14) {
                        Text(monthStart.formatted(.dateTime.month(.wide).year()))
                            .font(.title3.weight(.bold))
                            .padding(.horizontal)

                        CalendarMonthGridview(
                            selectedDate: $selectedDate,
                            highlightColor: highlightColor,
                            rangeOfTravel: start...end,
                            monthStart: monthStart)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
