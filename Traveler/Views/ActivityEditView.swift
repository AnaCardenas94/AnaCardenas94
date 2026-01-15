//
//  ActivityEditView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 25/11/25.
//

import SwiftUI
import SwiftData

struct ActivityEditView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State var title: String = ""
    @State var date: Date = Date()
    @State var startTime: Date? = nil
    @State var endTime: Date? = nil
    @State var details: String = ""
    @State private var errorMessage: String? = nil
    
    var activity: Activity?
    var onSave: ((Activity) -> Void)? = nil
    
    let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39)

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Form {
                    TextField("Title", text: $title)
                    DatePicker("Date",
                               selection: $date,
                               in: Date()...,
                               displayedComponents: .date)
                        .tint(mainColor)

                    DatePicker("Start time",
                               selection: Binding($startTime, replacingNilWith: Date()),
                               displayedComponents: .hourAndMinute)
                        .tint(mainColor)

                    DatePicker("End time",
                               selection: Binding($endTime, replacingNilWith: Date()),
                               displayedComponents: .hourAndMinute)
                        .tint(mainColor)
                    TextEditor(text: $details).frame(height: 120)
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                }
                .navigationTitle(activity == nil ? "Save activity" : "Edit activity")
                
                Button(action: saveActivity) {
                    Text(activity == nil ? "Save activity" : "Edit activity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(mainColor)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            }
            .onAppear {
                if let a = activity {
                    title = a.title
                    date = a.date
                    startTime = a.startTime
                    endTime = a.endTime
                    details = a.details
                }
            }
        }
    }

    private func saveActivity() {
        let act: Activity
        if let existing = activity {
            act = existing
            act.title = title
            act.date = Calendar.current.startOfDay(for: date)
            act.startTime = startTime
            act.endTime = endTime
            act.details = details
        } else {
            act = Activity(date: Calendar.current.startOfDay(for: date), title: title,
                           details: details, startTime: startTime,
                           endTime: endTime)
        }
        
        guard !act.title.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The title is required"
            return
        }
        
        guard !act.details.replacingOccurrences(of: " ", with: "").isEmpty else {
            errorMessage = "The details is required"
            return
        }
        
        onSave?(act)
        dismiss()
    }
}

#Preview {
    ActivityEditView(activity: nil) { _ in }
}

