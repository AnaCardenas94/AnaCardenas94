//
//  ExchnageCalculator.swift
//  Traveler
//
//  Created by citlali.a.cardenas on 6/11/25.
//
import SwiftUI
import Charts

struct ExchangeCalculatorView: View {

    @StateObject private var vm = ExchangeViewModel()
    
    private let mainColor = Color(red: 0.06, green: 0.27, blue: 0.39)

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {

                HStack(spacing: 12) {
                    CurrencyPicker(selection: $vm.from, mainColor: mainColor)
                    Image(systemName: "arrow.right.arrow.left")
                        .font(.title2)
                        .foregroundColor(mainColor)
                    CurrencyPicker(selection: $vm.to, mainColor: mainColor)
                }
                .padding(.horizontal)

                AmountInputView(vm: vm, mainColor: mainColor)
                
                if vm.result.0 > 0 {
                    Text("\(vm.amount, specifier: "%.2f") \(vm.from) = \(vm.result.0, specifier: "%.2f") \(vm.to)")
                        .font(.title2.bold())
                        .foregroundColor(mainColor)
                        .padding(.top)
                }

                if !vm.history.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Exchange Rate History")
                            .font(.headline)
                            .foregroundColor(mainColor)
                            .padding(.leading)
                            
                        Chart(vm.history) { data in
                            LineMark(x: .value("Day", data.day), y: .value("Rate", data.rate))
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(mainColor)
                            PointMark(x: .value("Day", data.day), y: .value("Rate", data.rate))
                                .foregroundStyle(mainColor)
                        }
                        .frame(height: 250)
                        .padding([.horizontal, .bottom])
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

struct AmountInputView: View {
    @ObservedObject var vm: ExchangeViewModel
    let mainColor: Color
    
    @FocusState private var isAmountFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Enter the Amount")
                .font(.headline)
                .foregroundColor(mainColor)
            
            HStack {
                
                TextField("0", value: $vm.amount, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(mainColor, lineWidth: 1)
                            .fill(Color(.systemGray6))
                    )
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .focused($isAmountFocused)
                
                Text(vm.from)
                    .font(.title3.bold())
                    .foregroundColor(mainColor)
                    .padding(.trailing, 10)
            }
            .padding(.horizontal)
            
            Button(action: {
                Task { await vm.convert() }
                isAmountFocused = false
            }) {
                Text("Convert")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(mainColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal)
    }
}

struct CurrencyPicker: View {
    @Binding var selection: String
    @ObservedObject var vm = ExchangeViewModel()
    let mainColor: Color

    var body: some View {
        Picker("", selection: $selection) {
            ForEach(vm.currencies) { c in
                Text("\(c.flag) \(c.code)").tag(c.code)
            }
        }
        .pickerStyle(.menu)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(mainColor, lineWidth: 1.3)
        )
        .tint(mainColor)
    }
}
