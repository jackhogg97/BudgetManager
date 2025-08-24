//
//  MonthlySpendViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 22/08/2025.
//

import Foundation
import SwiftData

@Observable
final class MonthlySpendViewModel {
  private let repo: DataRepository
  var showingDifference: Bool = UserDefaults.standard.bool(forKey: K.Keys.SHOWING_DIFFERENCE)
  private(set) var categories: [Category]
  private(set) var transactions: [Transaction]
  private(set) var dateRange: String

  init(_ repo: DataRepository, dataRange: String) {
    self.repo = repo
    categories = repo.fetch(Category.self)
    transactions = repo.fetch(Transaction.self)
    dateRange = dataRange
  }

  func getRowWidth(category: Category) -> Double {
    category.currentSpend / category.budget
  }

  func fetch() {
    categories = repo.fetch(Category.self)
    transactions = repo.fetch(Transaction.self)
  }

  func refresh(category: Category) -> Category {
    fetch()
    if let found = categories.first(where: { $0.id == category.id }) {
      return found
    }
    return category
  }
}
