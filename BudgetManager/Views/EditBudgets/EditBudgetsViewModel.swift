//
//  EditBudgetsViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 20/08/2025.
//

import Foundation
import SwiftData

@Observable
final class EditBudgetsViewModel {
  var isShowingSheet: Bool = false
  var startDate = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)
  var context: ModelContext
  var dataRepo: SwiftDataRepository
  var categories: [Category]
  var isKeyboardShowing: Bool = false
  var selectedCategory: Category?

  init(context: ModelContext, dataRepo: SwiftDataRepository) {
    self.context = context
    self.dataRepo = dataRepo
    categories = dataRepo.fetch(
      Category.self, sort: [SortDescriptor<Category>(\.budget, order: .reverse)]
    )
  }

  func fetchCategories() {
    categories = dataRepo.fetch(
      Category.self, sort: [SortDescriptor<Category>(\.budget, order: .reverse)]
    )
  }

  func addCategory() {
    let newCat = Category("Category \(categories.count + 1)", budget: 0.0, colorHex: "#0000FF")
    categories.append(newCat)
    context.insert(newCat)
  }

  func save() {
    UserDefaults.standard.setValue(startDate, forKey: K.Keys.PERIOD_DATE)
    do {
      try context.save()
    } catch {
      print("Save failed:", error)
    }
  }

  func deleteCategory(at offsets: IndexSet) {
    for index in offsets {
      if index < categories.count, index >= 0 {
        context.delete(categories[index])
      }
    }
  }
}
