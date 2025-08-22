//
//  TransactionsByDayMonthView.swift
//  BudgetManager
//
//  Created by Jack on 03/07/2024.
//

import SwiftData
import SwiftUI

struct TransactionsByDayMonthView: View {
  private let context: ModelContext
  @State var vm: TransactionsByDayViewModel

  init(_ context: ModelContext, transactions: [Transaction], dateRangeLabel: String) {
    self.context = context
    _vm = State(wrappedValue: TransactionsByDayViewModel(dateRangeLabel: dateRangeLabel, transactions: transactions, categoryName: nil))
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(vm.dateRangeLabel).font(.title3).frame(maxWidth: .infinity, alignment: .center)
      TransactionsListView(context: context, days: vm.days, transactionsByDay: vm.transactionByDay)
    }
  }
}

#Preview {
  let container = PreviewContext.GetContainer()

  TransactionsByDayMonthView(container.mainContext, transactions: [], dateRangeLabel: "15 January - 15 Febuary")
}
