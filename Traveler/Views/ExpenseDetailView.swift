//
//  ExpenseDetailView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//
import SwiftUI
import SwiftData
import PhotosUI

struct ExpenseDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Bindable var expense: ExpenseModel
    
    @State private var amountString: String = ""
    @State private var selectedImageItem: PhotosPickerItem? = nil

    let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39)

    var body: some View {
        NavigationStack {
            Form {
                Section("Receipt Image") {
                    if let img = expense.receiptImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(8)
                    } else {
                        Text("No receipt image available")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        PhotosPicker(
                            selection: $selectedImageItem,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Text(expense.receiptImage == nil ? "Add Image" : "Change Image")
                        }
                        .tint(mainColor)

                        Spacer()

                        if expense.receiptImage != nil {
                            Button("Delete Image") {
                                expense.receiptImageData = nil
                                selectedImageItem = nil
                            }
                            .tint(.red)
                        }
                    }
                }
                
                Section("Category") {
                    Picker("Category", selection: $expense.category) {
                        ForEach(Category.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                    .tint(mainColor)
                }
                
                Section("Details") {
                    TextField("Description", text: $expense.details)
                    TextField("Amount", text: $amountString)
                        .keyboardType(.decimalPad)
                        // *** onChange iOS 17+ ***
                        .onChange(of: amountString) {
                            if let value = Double(amountString) {
                                expense.amount = value
                            }
                        }
                    TextField("Paid by", text: $expense.paidBy)
                    DatePicker("Date", selection: $expense.date, displayedComponents: [.date])
                        .tint(mainColor)
                }
                
                Section("Movement Type") {
                    Picker("Type", selection: $expense.movement) {
                        ForEach(MovementType.allCases) { mov in
                            Text(mov.rawValue).tag(mov)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            .onAppear {
                amountString = String(format: "%.2f", expense.amount)
            }
            .onChange(of: selectedImageItem) {
                Task {
                    if let data = try? await selectedImageItem?.loadTransferable(type: Data.self) {
                        expense.receiptImageData = data
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

