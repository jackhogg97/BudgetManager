//
//  EditTransactionViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 21/08/2025.
//

import Foundation
import SwiftData

@Observable
final class EditTransactionViewModel {
  let dataRepo: DataRepository
  let categories: [Category]

  private(set) var existingTransaction: Transaction?

  var name: String = ""
  var category: Category?
  var amount: Double = 0.0
  var date: Date = .init()
  var notes: String = ""

  init(_ repo: DataRepository, transaction: Transaction?) {
    dataRepo = repo
    categories = repo.fetch(Category.self)

    if let transaction {
      existingTransaction = transaction
      name = transaction.name
      category = transaction.category
      amount = transaction.amount
      date = transaction.date
      notes = transaction.notes
    } else {
      category = categories.first
    }
  }

  func isSaveButtonDisabled() -> Bool {
    name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      || category == nil || amount == 0.0
  }

  func saveTransaction() {
    if isSaveButtonDisabled() { return }

    if let transaction = existingTransaction {
      transaction.name = name
      transaction.category = category!
      transaction.amount = amount
      transaction.date = date
      transaction.notes = notes
      dataRepo.save(transaction)
    } else {
      dataRepo.save(Transaction(
        name,
        category: category!,
        amount: amount,
        date: date,
        notes: notes
      ))
    }
  }
}
