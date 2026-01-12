//
//  TripCalendarView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//

import SwiftUI

struct TripCalendarView: View {

    @Binding var selectedDate: Date?
    
    let primaryColor: Color
    let startDate: Date
    let endDate: Date
    
    var body: some View {
        let days = Calendar.current.generateDates(between: startDate, and: endDate)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(days, id: \.self) { day in
                    let isSelected = selectedDate.map { Calendar.current.isDate($0, inSameDayAs: day) } ?? false
                    
                    VStack(spacing: 4) {
                        Text(day, format: .dateTime.weekday(.short))
                            .font(.caption)
                            .foregroundColor(isSelected ? .white : .primary)
                        Text(day, format: .dateTime.day())
                            .font(.title3.bold())
                            .foregroundColor(isSelected ? .white : .primary)
                    }
                    .frame(width: 70, height: 70)
                    .background(isSelected ? primaryColor : primaryColor.opacity(0.1))
                    .cornerRadius(14)
                    .onTapGesture { selectedDate = day }
                }
            }
            .padding(.vertical)
        }
    }
}
