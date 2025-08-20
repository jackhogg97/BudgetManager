//
//  TransactionsListViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 19/08/2025.
//

import Foundation
import SwiftData

@Observable
final class TransactionsListViewModel {
  var context: ModelContext
  var days: [String] = []
  var transactionsByDay: [String: [Transaction]] = [:]

  var selectedTransaction: Transaction?

  init(context: ModelContext, days: [String], transactionsByDay: [String: [Transaction]]) {
    self.context = context
    self.days = days
    self.transactionsByDay = transactionsByDay
  }

  func deleteTransaction(_ t: Transaction) {
    context.delete(t)
    try? context.save()
  }
}
