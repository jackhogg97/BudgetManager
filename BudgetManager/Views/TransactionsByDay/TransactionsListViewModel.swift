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
  var repo: DataRepository
  var days: [String] = []
  var transactionsByDay: [String: [Transaction]] = [:]

  var selectedTransaction: Transaction?

  init(_ repo: DataRepository, days: [String], transactionsByDay: [String: [Transaction]]) {
    self.repo = repo
    self.days = days
    self.transactionsByDay = transactionsByDay
  }

  func deleteTransaction(_ t: Transaction) {
    repo.delete(t)
  }
}
