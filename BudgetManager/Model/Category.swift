//
//  Category.swift
//  BudgetManager
//
//  Created by Jack Hogg on 19/08/2025.
//
//

import Foundation
import SwiftData

@Model
class Category {
  @Attribute(.unique) var id: UUID
  var name: String
  var cat_color: String
  var budget: Double

  @Relationship(deleteRule: .cascade, inverse: \Transaction.category)
  var transactions: [Transaction] = []

  var currentSpend: Double {
    transactions.reduce(0.0) { $0 + $1.amount }
  }

  init(id: UUID, name: String, budget: Double, colorHex: String) {
    self.id = id
    self.name = name
    self.budget = budget
    cat_color = colorHex
  }

  init(_ name: String, budget: Double, colorHex: String) {
    id = UUID()
    self.name = name
    self.budget = budget
    cat_color = colorHex
  }
}
