//
//  DataRepository.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import Foundation
import SwiftData

class DataRepository {
  private let context: ModelContext

  init(context: ModelContext) {
    self.context = context
  }

  init(_ context: ModelContext) {
    self.context = context
  }

  func save() {
    do {
      try context.save()
    } catch {
      print("Error saving: \(error)")
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

  func insert(_ object: some PersistentModel) {
    context.insert(object)
  }

  func delete<T: PersistentModel>(_ object: T) {
    context.delete(object)
    do {
      try context.save()
    } catch {
      print("Error saving \(T.self): \(error)")
    }
  }
}
