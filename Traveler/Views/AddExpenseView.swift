//
//  AddExpenseView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//

import SwiftUI

struct AddExpenseView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var category: Category = .food
    @State private var description = ""
    @State private var amount = ""
    @State private var paidBy = ""
    @State private var date = Date()
    @State private var movement: MovementType = .lent
    @State private var receiptImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var errorMessage: String = ""
    
    let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39)
    var onSave: ((ExpenseModel) -> Void)? = nil
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    Picker(selection: $category) {
                        ForEach(Category.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    } label: {
                        HStack {
                            Image(systemName: category.icon)
                            Text(category.rawValue)
                                .font(.body)
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(mainColor)
                }
                Section("Details") {
                    TextField("Description", text: $description)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Paid by", text: $paidBy)
                    DatePicker("Date", selection: $date, displayedComponents: [.date])
                        .tint(mainColor)
                }
                Section("Movement") {
                    Picker("Type", selection: $movement) {
                        ForEach(MovementType.allCases) { mov in
                            Text(mov.rawValue).tag(mov)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Receipt Image") {
                    if let img = receiptImage {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                    }
                    
                    Button("Add Image") {
                        showImagePicker = true
                    }
                    .tint(Color(red: 0.06, green: 0.27, blue: 0.39))
                    .alert(errorMessage, isPresented: .constant(!errorMessage.isEmpty)) {
                        Button("OK", role: .cancel) { }
                    }
                }
                
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        
                        if validateFields() {
                            guard let amountValue = Double(amount), !description.isEmpty, !paidBy.isEmpty else { return }
                            
                            let newExpense = ExpenseModel(
                                category: category,
                                details: description,
                                amount: amountValue,
                                paidBy: paidBy,
                                date: date,
                                movement: movement,
                                receiptImage: receiptImage
                            )
                            
                            onSave?(newExpense)
                            dismiss()
                        }
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $receiptImage)
            }
        }
    }
    
    func validateFields() -> Bool {
        if description.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Description is required."
            return false
        }

        if amount.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Amount is required."
            return false
        }

        if paidBy.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Paid by is required."
            return false
        }

        errorMessage = ""
        return true
    }

}
