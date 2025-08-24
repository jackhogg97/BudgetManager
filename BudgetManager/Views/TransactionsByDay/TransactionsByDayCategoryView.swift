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
      repo, dateRangeLabel: dateRangeLabel, transactions: category.transactions, categoryId: category.id
    ))
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(vm.category?.name ?? "Unknown category?").font(.title3).frame(maxWidth: .infinity, alignment: .center)
      Text(vm.dateRangeLabel).font(.caption).frame(maxWidth: .infinity, alignment: .center)
      TransactionsListView(data, days: vm.days, transactionsByDay: vm.transactionByDay)
    }
    .onAppear {
      print("appearing...")
      if vm.categoryId != nil {
        vm.fetchCategory(id: vm.categoryId!)
      }
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
