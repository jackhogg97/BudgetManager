//
//  TransactionsByDayViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 18/08/2025.
//

import Foundation

final class TransactionsByDayViewModel: ObservableObject {
  @Published var days: [String] = []
  @Published var transactionByDay: [String: [Transaction]] = [:]
  @Published var dateRangeLabel: String
  @Published var category: String?

  private let dateFormatter: DateFormatter

  init(dateRangeLabel: String, transactions: [Transaction], category: String? = nil) {
    dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    dateFormatter.locale = Locale(identifier: "en_GB")

    self.category = category
    self.dateRangeLabel = dateRangeLabel
    (days, transactionByDay) = getTransactionsKeyedByDay(transactions: transactions, category: category)
  }

  // Returns an array of date keys and a dictionary with the key and whose values are the transactions
  // We need to return an array of keys because Swift does not support ordered dictionaries
  // Optionally, will filter transactions based on the category if present
  func getTransactionsKeyedByDay(transactions: [Transaction], category: String? = nil) -> ([String], [String: [Transaction]]) {
    var dates: [String] = []

    let filtered = filterTransactionsByCategory(transactions: transactions, category: category)

    let sorted = filtered.sorted(by: { $0.date! > $1.date! })

    let transactionByDate = Dictionary(grouping: sorted) { (element: Transaction) in
      let dateStr = dateFormatter.string(from: element.date!)
      if !dates.contains(dateStr) {
        dates.append(dateStr)
      }
      return dateFormatter.string(from: element.date!)
    }

    return (dates, transactionByDate)
  }

  private func filterTransactionsByCategory(transactions: [Transaction], category: String? = nil) -> [Transaction] {
    if category == nil {
      return transactions
    }

    return transactions.filter { $0.category == category }
  }
}
