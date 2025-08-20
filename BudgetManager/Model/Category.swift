//
//  Category.swift
//  BudgetManager
//
//  Created by Jack Hogg on 19/08/2025.
//
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class Category {
  var id: UUID
  var name: String
  var cat_color: String
//  var color: Color

  var currentSpend: Double = 0.0
  var budget: Double = 0.0

  init(id: UUID, name: String, budget: Double, colorHex: String) {
    self.id = id
    self.name = name
    self.budget = budget
    cat_color = colorHex
  }
}
