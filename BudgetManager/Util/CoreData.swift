//
//  CoreData.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import CoreData

protocol CategoryRepository {
  func fetchCategories() -> [Category]
  func save(_ category: Category)
}

protocol TransactionRepository {
  func fetchTransactions() -> [Transaction]
  func save(_ transaction: Transaction)
}

class CoreDataCategoryRepository: CategoryRepository {
  private let context: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.context = context
  }

  func fetchCategories() -> [Category] {
    let request = Category.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Category.budget, ascending: false)]
    do {
      return try context.fetch(request)
    } catch {
      print("Error fetching categories: \(error)")
      return []
    }
  }

  func save(_: Category) {
    do {
      try context.save()
    } catch {
      print("Error saving category: \(error)")
    }
  }
}

class CoreDataTransactionRepository: TransactionRepository {
  private let context: NSManagedObjectContext

  init(context: NSManagedObjectContext) {
    self.context = context
  }

  func fetchTransactions() -> [Transaction] {
    let request = Transaction.fetchRequest()
    do {
      return try context.fetch(request)
    } catch {
      print("Error fetching transactions: \(error)")
      return []
    }
  }

  func save(_: Transaction) {
    do {
      try context.save()
    } catch {
      print("Error saving transaction: \(error)")
    }
  }
}
