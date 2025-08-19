//
//  TransactionsByDayMonthView.swift
//  BudgetManager
//
//  Created by Jack on 03/07/2024.
//

import SwiftUI

struct TransactionsByDayMonthView: View {
  @Environment(\.managedObjectContext) var moc
  @StateObject var vm: TransactionsByDayViewModel

  init(transactions: [Transaction], dateRangeLabel: String) {
    _vm = StateObject(wrappedValue: TransactionsByDayViewModel(dateRangeLabel: dateRangeLabel, transactions: transactions))
  }

  var body: some View {
    TransactionsListView(moc: moc, days: vm.days, transactionsByDay: vm.transactionByDay, title: vm.dateRangeLabel)
  }
}

#Preview {
  TransactionsByDayMonthView(transactions: [], dateRangeLabel: "15 January - 15 Febuary")
}
