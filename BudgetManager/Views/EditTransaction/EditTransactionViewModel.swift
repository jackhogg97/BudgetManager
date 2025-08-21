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
  var dataRepo: SwiftDataRepository
  var context: ModelContext

  var categories: [Category]
  var currentTransaction: Transaction
  var selectedCategory: Category?

  init(_ context: ModelContext, repo: SwiftDataRepository,
       transaction: Transaction?)
  {
    dataRepo = repo
    self.context = context
    categories = repo.fetch(Category.self)
    currentTransaction = transaction ?? Transaction(
      name: "",
      category: nil,
      amount: 0.0,
      date: Date(),
      notes: nil,
    )
    // Hmm
    selectedCategory = categories.first
  }

  func isSaveButtonDisabled() -> Bool {
    currentTransaction.name == "" || currentTransaction.category == nil || currentTransaction.amount == 0.0
  }

  func saveTransaction() {
    if isSaveButtonDisabled() {
      return
    }
    dataRepo.save(currentTransaction)
    try? context.save()
  }
}
