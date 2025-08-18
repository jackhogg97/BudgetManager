//
//  CategoryView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 16/11/2023.
//

import SwiftUI

struct CategoryView: View {
  @StateObject var vm: TransactionsByDayViewModel

  init(category: String, transactions: [Transaction], dateRangeLabel: String) {
    _vm = StateObject(wrappedValue: TransactionsByDayViewModel(dateRangeLabel: dateRangeLabel, transactions: transactions, category: category))
  }

  var body: some View {
    TransactionsListView(days: vm.days, transactionsByDay: vm.transactionByDay, title: "\(String(describing: vm.category ?? "Unknown")): \(vm.dateRangeLabel)")
  }
}

#Preview {
  CategoryView(category: "Category Title", transactions: [], dateRangeLabel: "15 January - 15 Febuary")
}
