//
//  CategoryModel.swift
//  BudgetManager
//
//  Created by Jack on 16/10/2024.
//

import Foundation
import SwiftUI

struct CategoryModel: Identifiable {
  var id: UUID
  var name: String
  var budget: Double
  var color: Color

  init(from category: Category) {
    id = category.id ?? UUID()
    name = category.wrappedName
    budget = category.budget
    color = Color(hex: category.cat_color ?? "") ?? .blue
  }

  init(id: UUID, name: String, budget: Double, color: Color) {
    self.id = id
    self.name = name
    self.budget = budget
    self.color = color
  }
}
