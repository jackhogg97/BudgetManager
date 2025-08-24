//
//  DataRepository.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import Foundation
import OSLog
import SwiftData

class DataRepository {
  let logger = Logger()
  private let context: ModelContext

  init(context: ModelContext) {
    self.context = context
  }

  init(_ context: ModelContext) {
    self.context = context
  }

  func save() {
    logger.debug("Saving")
    do {
      try context.save()
    } catch {
      logger.error("Error saving: \(error)")
    }
  }

  func save<T: BaseModel>(_ object: T) {
    logger.debug("Saving \(object.name)")
    context.insert(object)
    do {
      try context.save()
    } catch {
      logger.error("Error saving \(T.self): \(error)")
    }
  }

  func fetch<T: BaseModel>(
    _: T.Type,
    sort: [SortDescriptor<T>] = [],
    predicate: Predicate<T>? = nil
  ) -> [T] {
    do {
      let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sort)
      return try context.fetch(descriptor)
    } catch {
      logger.error("Error fetching \(T.self): \(error)")
      return []
    }
  }

  func insert(_ object: some BaseModel) {
    logger.debug("Inserting \(object.name)")
    context.insert(object)
  }

  func delete<T: BaseModel>(_ object: T) {
    logger.debug("Deleting \(object.name)")
    context.delete(object)
    do {
      try context.save()
    } catch {
      logger.error("Error saving \(T.self): \(error)")
    }
  }
}
