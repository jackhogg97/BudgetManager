//
//  TransactionsByDayMonthView.swift
//  BudgetManager
//
//  Created by Jack on 03/07/2024.
//

import SwiftUI

struct TransactionsByDayMonthView: View {
  @Environment(\.modelContext) var context
  @StateObject var vm: TransactionsByDayViewModel

  init(transactions: [Transaction], dateRangeLabel: String) {
    _vm = StateObject(wrappedValue: TransactionsByDayViewModel(dateRangeLabel: dateRangeLabel, transactions: transactions))
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(vm.dateRangeLabel).font(.title3).frame(maxWidth: .infinity, alignment: .center)
      TransactionsListView(context: context, days: vm.days, transactionsByDay: vm.transactionByDay)
    }
  }
}

#Preview {
  TransactionsByDayMonthView(transactions: [], dateRangeLabel: "15 January - 15 Febuary")
}
