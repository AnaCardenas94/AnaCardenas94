//
//  Planner.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//
import SwiftUI
import SwiftData

struct TripPlannerView: View {

    @Environment(\.modelContext) private var context
    @Query var activities: [Activity]
    
    @StateObject private var vm = TripPlannerViewModel()
    @State private var dateFrom: Date = Date()
    @State private var dateTo: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
    @State private var showCreate = false
    @State private var selectingStartDate = true
    
    let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39)

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                dateRangeSelector
                Divider()
                calendarSection
                Divider()
                activitiesSection
                Spacer()
            }
            .navigationTitle("")
            .toolbar {
                Button(action: { showCreate = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(vm.primaryColor)
                }
            }
            .sheet(isPresented: $showCreate) {
                ActivityEditView(activity: nil) { addActivity($0) }
            }
        }
        .onAppear {
            vm.activities = activities.sorted { $0.date < $1.date }
        }
        .onChange(of: activities) { _, new in
            vm.activities = new.sorted { $0.date < $1.date }
        }
    }
}

extension TripPlannerView {
    @ViewBuilder
    private var dateRangeSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Selecciona el rango del viaje")
                .font(.title2).bold()
            DatePicker("Desde", selection: $dateFrom, in: Date()..., displayedComponents: .date)
                .tint(mainColor)
                .foregroundColor(mainColor)

            DatePicker("Hasta", selection: $dateTo, in: dateFrom..., displayedComponents: .date)
                .tint(mainColor)
                .foregroundColor(mainColor)
        }
        .padding(.horizontal)
        .padding(.top)
    }

    @ViewBuilder
    private var calendarSection: some View {
        FullCalendarView(selectedDate: $vm.selectedDate, highlightColor: vm.primaryColor, start: dateFrom, end: dateTo)
        .frame(maxHeight: 350)
        .padding(.horizontal)
        .onChange(of: vm.selectedDate) { _, newDate in

        }
    }

    @ViewBuilder
    private var activitiesSection: some View {
        if let date = vm.selectedDate {
            ActivitiesSectionView(vm: vm, date: date, deleteAction: deleteActivity)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        } else {
            VStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text("Select one day for view the activities.")
                    .font(.default)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

extension TripPlannerView {

    func addActivity(_ activity: Activity) {
        if activity.modelContext == nil { context.insert(activity) }
        do {
            try context.save()
            vm.activities.append(activity)
            vm.activities.sort { $0.date < $1.date }
        } catch {
            vm.errorMessage = "Error al guardar la actividad: \(error.localizedDescription)"
        }
    }

    func deleteActivity(activity: Activity) {
        context.delete(activity)
        do {
            try context.save()
            vm.activities.removeAll { $0.id == activity.id }
        } catch {
            vm.errorMessage = "Error al eliminar actividad: \(error.localizedDescription)"
        }
    }
}

#Preview {
    TripPlannerView()
        .modelContainer(for: Activity.self, inMemory: true)
}
