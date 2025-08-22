//
//  TransactionsByDayCategoryView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 16/11/2023.
//

import SwiftData
import SwiftUI

struct TransactionsByDayCategoryView: View {
  private let data: DataRepository
  @State var vm: TransactionsByDayViewModel

  init(_ repo: DataRepository, category: Category, transactions _: [Transaction], dateRangeLabel: String) {
    data = repo
    _vm = State(wrappedValue: TransactionsByDayViewModel(
      dateRangeLabel: dateRangeLabel, transactions: category.transactions, categoryName: category.name
    ))
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(vm.categoryName ?? "Unknown Category?").font(.title3).frame(maxWidth: .infinity, alignment: .center)
      Text(vm.dateRangeLabel).font(.caption).frame(maxWidth: .infinity, alignment: .center)
      TransactionsListView(data, days: vm.days, transactionsByDay: vm.transactionByDay)
    }
  }
}

#Preview {
  TransactionsByDayCategoryView(
    PreviewContext.MockRepo(),
    category: PreviewContext.Category(),
    transactions: [PreviewContext.Transaction()],
    dateRangeLabel: "15 January - 15 Febuary"
  )
}
