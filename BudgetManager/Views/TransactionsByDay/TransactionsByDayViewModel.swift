//
//  TransactionsByDayViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 18/08/2025.
//

import Foundation

@Observable
final class TransactionsByDayViewModel: ObservableObject {
  var days: [String] = []
  var transactionByDay: [String: [Transaction]] = [:]
  var dateRangeLabel: String
  var categoryName: String?

  private let dateFormatter: DateFormatter

  init(dateRangeLabel: String, transactions: [Transaction], categoryName: String?) {
    dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    dateFormatter.locale = Locale(identifier: "en_GB")

    self.categoryName = categoryName
    self.dateRangeLabel = dateRangeLabel

    (days, transactionByDay) = getTransactionsKeyedByDay(transactions: transactions)
  }

  // Returns an array of date keys and a dictionary with the key and whose values are the transactions
  // We need to return an array of keys because Swift does not support ordered dictionaries
  // Optionally, will filter transactions based on the category if present
  func getTransactionsKeyedByDay(transactions: [Transaction]) -> ([String], [String: [Transaction]]) {
    var dates: [String] = []

    let sorted = transactions.sorted(by: { $0.date > $1.date })

    let transactionByDate = Dictionary(grouping: sorted) { (element: Transaction) in
      let dateStr = dateFormatter.string(from: element.date)
      if !dates.contains(dateStr) {
        dates.append(dateStr)
      }
      return dateFormatter.string(from: element.date)
    }

    return (dates, transactionByDate)
  }
}
