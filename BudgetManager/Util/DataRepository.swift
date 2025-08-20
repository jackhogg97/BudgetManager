//
//  DataRepository.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import Foundation
import SwiftData

class SwiftDataRepository {
  private let context: ModelContext

  init(context: ModelContext) {
    self.context = context
  }

  func fetch<T: PersistentModel>(
    _: T.Type,
    sort: [SortDescriptor<T>] = []
  ) -> [T] {
    do {
      let descriptor = FetchDescriptor<T>(sortBy: sort)
      return try context.fetch(descriptor)
    } catch {
      print("Error fetching \(T.self): \(error)")
      return []
    }
  }

  func save<T: PersistentModel>(_ object: T) {
    context.insert(object)
    do {
      try context.save()
    } catch {
      print("Error saving \(T.self): \(error)")
    }
  }
}
