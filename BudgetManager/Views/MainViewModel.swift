//
//  MainViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import CoreData
import Foundation
import SwiftUI

enum ChevronDirection {
  case left, right
}

final class MainViewModel: ObservableObject {
  let PERIOD_START_DATE = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)

  @Published var categories: [Category]
  @Published var transactions: [Transaction]
  @Published var selectedTabIndex: Int = 0
  @Published var showingAddTransaction = false

  init(categoryRepo: CategoryRepository, transactionRepo: TransactionRepository) {
    categories = categoryRepo.fetchCategories()
    transactions = transactionRepo.fetchTransactions()
  }

  func getTransactionsPerMonth() -> ([String], [String: [Transaction]]) {
    let months = Set(transactions.compactMap { $0.date!.setDay(day: PERIOD_START_DATE) }).sorted(by: <)
    let ranges: [[Date]] = months.map { month in [month, month.incrementMonth()] }

    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yy"

    var objects: [String: [Transaction]] = [:]
    var keys: [String] = []
    for range in ranges {
      let key = formatter.string(from: range[0]) + " - " + formatter.string(from: range[1])
      for transaction in transactions {
        if transaction.date! > range[0], transaction.date! < range[1] {
          if var transactionInMonth = objects[key] {
            transactionInMonth.append(transaction)
            objects[key] = transactionInMonth
          } else {
            objects[key] = [transaction]
            keys.append(key)
          }
        }
      }
    }

    return (keys, objects)
  }

  func calculateChevronColor(index: Int, length: Int, direction: ChevronDirection) -> Color {
    if direction == .left, index == 0 {
      return .black
    }
    if direction == .right, index == length - 1 {
      return .black
    }
    return .gray
  }
}
