//
//  TransactionsByDayMonthView.swift
//  BudgetManager
//
//  Created by Jack on 03/07/2024.
//

import SwiftData
import SwiftUI

struct TransactionsByDayMonthView: View {
  private let data: DataRepository
  @State var vm: TransactionsByDayViewModel

  init(_ data: DataRepository, transactions: [Transaction], dateRangeLabel: String) {
    self.data = data
    _vm = State(wrappedValue: TransactionsByDayViewModel(dateRangeLabel: dateRangeLabel, transactions: transactions, categoryName: nil))
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text(vm.dateRangeLabel).font(.title3).frame(maxWidth: .infinity, alignment: .center)
      TransactionsListView(data, days: vm.days, transactionsByDay: vm.transactionByDay)
    }
  }
}

#Preview {
  TransactionsByDayMonthView(PreviewContext.MockRepo(), transactions: [PreviewContext.Transaction()], dateRangeLabel: "15 January - 15 Febuary")
}
