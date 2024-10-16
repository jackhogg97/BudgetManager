//
//  CategoryModel.swift
//  BudgetManager
//
//  Created by Jack on 16/10/2024.
//

import Foundation

struct CategoryModel
{
  var id: UUID
  var name: String
  var budget: Double
  var color: Float

  init(from: Category)
  {
    id = from.id ?? UUID()
    name = from.wrappedName
    budget = from.budget
    color = from.color
  }

  init(id: UUID, name: String, budget: Double, color: Float)
  {
    self.id = id
    self.name = name
    self.budget = budget
    self.color = color
  }
}
