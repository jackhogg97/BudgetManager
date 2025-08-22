//
//  TransactionsByDayCategoryView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 16/11/2023.
//

import SwiftData
import SwiftUI

struct TransactionsByDayCategoryView: View {
  private var context: ModelContext
  @State var vm: TransactionsByDayViewModel

  init(_ context: ModelContext, category: Category, transactions _: [Transaction], dateRangeLabel: String) {
    self.context = context
    _vm = State(wrappedValue: TransactionsByDayViewModel(
      dateRangeLabel: dateRangeLabel, transactions: category.transactions, categoryName: category.name
    )
    )
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(vm.categoryName ?? "Unknown Category?").font(.title3).frame(maxWidth: .infinity, alignment: .center)
      Text(vm.dateRangeLabel).font(.caption).frame(maxWidth: .infinity, alignment: .center)
      TransactionsListView(context: context, days: vm.days, transactionsByDay: vm.transactionByDay)
    }
  }
}

#Preview {
  let container = PreviewContext.GetContainer()
  let category = Category("Category", budget: 100.0, colorHex: "#0000FF")
  container.mainContext.insert(category)

  return TransactionsByDayCategoryView(container.mainContext, category: category, transactions: [], dateRangeLabel: "15 January - 15 Febuary")
}
