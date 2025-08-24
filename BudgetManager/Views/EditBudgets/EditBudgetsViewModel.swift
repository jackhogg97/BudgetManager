//
//  EditBudgetsViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 20/08/2025.
//

import Foundation
import SwiftData
import SwiftUICore

@Observable
final class EditBudgetsViewModel {
  var isShowingSheet: Bool = false
  var startDate = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)
  var repo: DataRepository
  var categories: [Category]
  var isKeyboardShowing: Bool = false
  var selectedCategory: Category?

  init(_ repo: DataRepository) {
    self.repo = repo
    self.repo = repo
    categories = repo.fetch(
      Category.self, sort: [SortDescriptor<Category>(\.budget, order: .reverse)]
    )
  }

  func fetchCategories() {
    categories = repo.fetch(
      Category.self, sort: [SortDescriptor<Category>(\.budget, order: .reverse)]
    )
  }

  func addCategory() {
    let newCat = Category("Category \(categories.count + 1)", budget: 0.0, colorHex: "#0000FF")
    categories.append(newCat)
    repo.save(newCat)
  }

  func save() {
    UserDefaults.standard.setValue(startDate, forKey: K.Keys.PERIOD_DATE)
    repo.save()
  }

  func setCategoryColour(_ c: Category, colour: Color) {
    if let category = categories.first(where: { $0.id == c.id }) {
      category.cat_color = colour.toHex() ?? K.Colours.DEFAULT_HEX
    }
  }

  func deleteCategory(at offsets: IndexSet) {
    for index in offsets {
      if index < categories.count, index >= 0 {
        repo.delete(categories[index])
      }
    }
  }
}
