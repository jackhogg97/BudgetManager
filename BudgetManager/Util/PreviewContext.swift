//
//  PreviewContext.swift
//  BudgetManager
//
//  Created by Jack Hogg on 22/08/2025.
//

import Foundation
import SwiftData

enum PreviewContext {
  // Create an in-memory container for preview
  static func GetContainer() -> ModelContainer {
    do {
      let config = ModelConfiguration(isStoredInMemoryOnly: true)
      return try ModelContainer(for: BudgetManager.Category.self, BudgetManager.Transaction.self, configurations: config)
    } catch {
      fatalError("Failed to create preview container: \(error)")
    }
  }

  @MainActor
  static func MockRepo() -> DataRepository {
    let container = PreviewContext.GetContainer()
    let context = container.mainContext

    let bills = BudgetManager.Category("Bills", budget: 1000.00, colorHex: K.Colours.DEFAULT_HEX)
    let groceries = BudgetManager.Category("Groceries", budget: 100.00, colorHex: K.Colours.DEFAULT_HEX)
    let rent = BudgetManager.Transaction("Rent", category: bills, amount: 1000, date: Date())
    let food = BudgetManager.Transaction("Food", category: groceries, amount: 50.00, date: Date())

    context.insert(bills)
    context.insert(groceries)
    context.insert(rent)
    context.insert(food)

    return DataRepository(context: context)
  }

  static func Category() -> Category {
    BudgetManager.Category("Bills", budget: 1000.00, colorHex: K.Colours.DEFAULT_HEX)
  }

  static func Transaction() -> Transaction {
    let bills = BudgetManager.Category("Bills", budget: 1000.00, colorHex: K.Colours.DEFAULT_HEX)
    return BudgetManager.Transaction("Rent", category: bills, amount: 1000, date: Date())
  }
}
