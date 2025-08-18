//
//  DateRangeView.swift
//  BudgetManager
//
//  Created by Jack on 03/07/2024.
//

import SwiftUI

struct DateRangeView: View {
  var transactions: [Transaction]
  var dateRange: String

  var body: some View {
    let (days, transactions) = getTransactionsKeyedByDay()

    TransactionsListView(
      days: days,
      transactions: transactions,
      title: dateRange
    )
  }

  // TODO: Refactor this and CategoryView functions
  func getTransactionsKeyedByDay() -> ([String], [String: [FetchedResults<Transaction>.Element]]) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    dateFormatter.locale = Locale(identifier: "en_GB")

    var dates: [String] = []
    let sortedTransactions = transactions.sorted(by: { $0.date! > $1.date! })
    let transactionByDate = Dictionary(grouping: sortedTransactions) { (element: Transaction) in
      let dateStr = dateFormatter.string(from: element.date!)
      if !dates.contains(dateStr) {
        dates.append(dateStr)
      }
      return dateFormatter.string(from: element.date!)
    }

    return (dates, transactionByDate)
  }
}

#Preview {
  DateRangeView(transactions: [], dateRange: "15 January - 15 Febuary")
}
