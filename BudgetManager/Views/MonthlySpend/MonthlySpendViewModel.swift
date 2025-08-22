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
  let repo: DataRepository
  var showingDifference: Bool = UserDefaults.standard.bool(forKey: K.Keys.SHOWING_DIFFERENCE)
  var categories: [Category]
  var dateRange: String

  init(_ repo: DataRepository, dataRange: String) {
    self.repo = repo
    categories = repo.fetch(Category.self)
    dateRange = dataRange
  }

  func getRowWidth(category: Category) -> Double {
    category.currentSpend / category.budget
  }

  func fetch() {
    categories = repo.fetch(Category.self)
  }
}
