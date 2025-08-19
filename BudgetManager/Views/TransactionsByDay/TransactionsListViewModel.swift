//
//  TransactionsListViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 19/08/2025.
//

import CoreData
import Foundation

@Observable
final class TransactionsListViewModel {
  var moc: NSManagedObjectContext
  var days: [String] = []
  var transactionsByDay: [String: [Transaction]] = [:]

  var selectedTransaction: Transaction?

  init(moc: NSManagedObjectContext, days: [String], transactionsByDay: [String: [Transaction]]) {
    self.moc = moc
    self.days = days
    self.transactionsByDay = transactionsByDay
  }

  func deleteTransaction(_ t: Transaction) {
    moc.delete(t)
    try? moc.save()
  }
}
