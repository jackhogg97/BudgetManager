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
      return try ModelContainer(for: Category.self, Transaction.self, configurations: config)
    } catch {
      fatalError("Failed to create preview container: \(error)")
    }
  }
}
