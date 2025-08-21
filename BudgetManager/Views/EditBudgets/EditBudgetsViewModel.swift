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
  let startDate = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)

  var context: ModelContext
  var categories: [Category]
  var isKeyboardShowing: Bool = false

//  @Query(FetchDescriptor(sortBy: [SortDescriptor<Category>(\.budget, order: .reverse)])) var categories: [Category]

  init(context: ModelContext, dataRepo: SwiftDataRepository) {
    self.context = context
    categories = dataRepo.fetch(Category.self, sort: [SortDescriptor<Category>(\.budget, order: .reverse)])
  }
}
