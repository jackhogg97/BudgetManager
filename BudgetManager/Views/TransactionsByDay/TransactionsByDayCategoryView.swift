//
//  TransactionsByDayCategoryView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 16/11/2023.
//

import SwiftUI

struct TransactionsByDayCategoryView: View {
  @Environment(\.managedObjectContext) var moc
  @StateObject var vm: TransactionsByDayViewModel

  init(category: String, transactions: [Transaction], dateRangeLabel: String) {
    _vm = StateObject(wrappedValue: TransactionsByDayViewModel(dateRangeLabel: dateRangeLabel, transactions: transactions, category: category))
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(vm.category ?? "Unknown category?").font(.title3).frame(maxWidth: .infinity, alignment: .center)
      Text(vm.dateRangeLabel).font(.caption).frame(maxWidth: .infinity, alignment: .center)
      TransactionsListView(moc: moc, days: vm.days, transactionsByDay: vm.transactionByDay)
    }
  }
}

#Preview {
  TransactionsByDayCategoryView(category: "Category Title", transactions: [], dateRangeLabel: "15 January - 15 Febuary")
}
