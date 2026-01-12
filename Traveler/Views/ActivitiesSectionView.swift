//
//  ActivitiesSectionView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//
import SwiftUI
import Foundation

struct ActivitiesSectionView: View {
    
    @ObservedObject var vm: TripPlannerViewModel
    
    let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39)
    
    var date: Date
    var deleteAction: ((Activity) -> Void)? = nil

    var body: some View {
        let list = vm.activities(for: date)

        VStack(alignment: .leading, spacing: 40) {

            Text(date.formatted(.dateTime.weekday(.wide).month().day()))
                .font(.title3.bold())
                .padding(.horizontal)

            if list.isEmpty {
                Text("No activities recorded")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

            } else {
                List {
                    ForEach(list) { activity in
                        NavigationLink(destination: ActivityEditView(activity: activity, onSave: { _ in })) {
                            ActivityTimelineRow(
                                activity: activity,
                                mainColor: mainColor
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 8)
                    }
                    .onDelete { indexSet in
                        guard let deleteAction = deleteAction else { return }
                        for index in indexSet {
                            let activityToDelete = list[index]
                            deleteAction(activityToDelete)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(maxHeight: 500)
                .selectionDisabled(true)
            }
        }
    }
}

struct ActivityTimelineRow: View {
    let activity: Activity
    let mainColor: Color

    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    Circle()
                        .fill(colorForCategory(activity.category))
                        .frame(width: 12, height: 12)
                        .padding(.top, 8)

                    Rectangle()
                        .fill(colorForCategory(activity.category))
                        .frame(width: 3, height: geo.size.height - 20)
                    
                    Circle()
                        .fill(colorForCategory(activity.category))
                        .frame(width: 12, height: 12)
                        .padding(.bottom, 10)
                }
            }
            .frame(width: 30)
            .offset(x: 20)

            ActivityCardView(activity: activity, mainColor: mainColor)
                .padding(.leading, 60)
                .padding(.trailing, 16)
        }
    }
    
    private func colorForCategory(_ category: String?) -> Color {
        guard let c = category else { return mainColor }
        switch c.lowercased() {
        case "travel", "vuelo": return .orange
        case "meeting", "reunión": return .blue
        case "personal": return .pink
        case "musemum": return .purple
        default: return mainColor
        }
    }
    
    private func iconForCategory(_ category: String?) -> String {
        guard let c = category else { return "calendar.circle.fill" }
        switch c.lowercased() {
        case "travel", "vuelo": return "airplane.circle.fill"
        case "meeting", "reunión": return "person.3.fill"
        case "personal": return "heart.circle.fill"
        case "musemum": return "building.columns.circle.fill"
        default: return "calendar.circle.fill"
        }
    }
}

struct ActivityCardView: View {
    let activity: Activity
    let mainColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack {
                Image(systemName: iconForCategory(activity.category))
                    .foregroundColor(colorForCategory(activity.category).opacity(0.5))
                    .font(.title)
                    
                Text(activity.title)
                    .font(.headline)
            }
            Text(activity.startTime ?? Date(), style: .date)
                .font(.title3)
                .foregroundStyle(.secondary)
            HStack {
                Text("Start time")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(activity.startTime ?? Date(), style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(calcularDuracion(inicio: activity.startTime ?? Date(), fin: activity.endTime ?? Date()))
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack{
                Text("End time")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(activity.endTime ?? Date(), style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.08), lineWidth: 1)
        )
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    func calcularDuracion(inicio fechaInicio: Date, fin fechaFin: Date) -> String {
        let calendario = Calendar.current
        let componentes = calendario.dateComponents([.hour, .minute], from: fechaInicio, to: fechaFin)
            
        let horas = componentes.hour ?? 0
        let minutos = componentes.minute ?? 0
            
        return "⏱️ Duration \(horas)h \(minutos)m"
    }
    
    private func iconForCategory(_ category: String?) -> String {
        guard let c = category else { return "calendar.circle.fill" }
        switch c.lowercased() {
        case "travel", "vuelo": return "airplane.circle.fill"
        case "meeting", "reunión": return "person.3.fill"
        case "personal": return "heart.circle.fill"
        case "musemum": return "building.columns.circle.fill"
        default: return "calendar.circle.fill"
        }
    }
    
    private func colorForCategory(_ category: String?) -> Color {
        guard let c = category else { return mainColor }
        switch c.lowercased() {
        case "travel", "vuelo": return .orange
        case "meeting", "reunión": return .blue
        case "personal": return .pink
        case "musemum": return .purple
        default: return mainColor
        }
    }
}
