//
//  ExpensesListView.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 21/11/25.
//

import SwiftUI
import SwiftData

struct ExpensesListView: View {

    @Environment(\.modelContext) private var context
    @Query(sort: \ExpenseModel.date, order: .reverse) var expenses: [ExpenseModel]
    
    @StateObject private var vm = ExpensesViewModel()

    @State private var showAddExpense = false
    @State private var errorMessage: String? = nil
    
    let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39)

    var body: some View {
        NavigationStack {
            VStack {
                header

                if expenses.isEmpty {
                    VStack {
                        Spacer()
                        ContentUnavailableView(
                            "Track your expenses",
                            systemImage: "creditcard.fill",
                            description: Text("Tap the plus button to add your first expense.")
                        )
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(expenses, id: \.self) { expense in
                            NavigationLink {
                                ExpenseDetailView(expense: expense)
                            } label: {
                                ExpenseRowView(expense: expense)
                                    .alignmentGuide(.listRowSeparatorLeading) { d in
                                        d[.leading]
                                    }
                            }
                        }
                        .onDelete(perform: deleteExpenseHandler)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .toolbar {
                Button(action: { showAddExpense = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(mainColor)
                }
            }
            .sheet(isPresented: $showAddExpense) {
                AddExpenseView() { addExpense($0) }
            }
            .alert("An error occurred", isPresented: Binding<Bool>(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .onChange(of: expenses) {
            vm.expenses = expenses
        }
        .onAppear {
            vm.expenses = expenses
        }
    }
    
    func deleteExpenseHandler(offsets: IndexSet) {
        for index in offsets {
            let expenseToDelete = expenses[index]
            context.delete(expenseToDelete)
        }
        do {
            try context.save()
        } catch {
            errorMessage = "Error deleting expense: \(error.localizedDescription)"
        }
    }
    
    func addExpense(_ expense: ExpenseModel) {
        context.insert(expense)
        do {
            try context.save()
        } catch {
            errorMessage = "Error saving expense: \(error.localizedDescription)"
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Trip Net Balance:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Spacer()
                Text(vm.netBalance, format: vm.currencyFormatter)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(vm.netBalance == 0 ? .gray : mainColor)
            }
            
            Divider()

            HStack {
                VStack(alignment: .leading) {
                    Text("Total Lent:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(vm.totalLent, format: vm.currencyFormatter)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(UIColor(red: 0.33, green: 0.69, blue: 0.55, alpha: 1.00)))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Total Borrowed:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(vm.totalBorrowed, format: vm.currencyFormatter)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(Color(UIColor(red: 0.93, green: 0.41, blue: 0.31, alpha: 1.00))))
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Individual Balances:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text(vm.balanceMessage)
                    .font(.footnote)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
