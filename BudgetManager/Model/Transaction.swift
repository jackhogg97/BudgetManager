//
//  Transaction.swift
//  BudgetManager
//
//  Created by Jack Hogg on 19/08/2025.
//
//

import Foundation
import SwiftData

@Model
class Transaction {
  var id: UUID
  var name: String
  var categoryName: String
  var amount: Double
  var date: Date
  var notes: String
  var category: Category?
  
  init(name: String, category: Category?, amount: Double, date: Date, notes: String? = nil) {
    id = UUID()
    self.name = name
    self.categoryName = ""
    self.category = category
    self.amount = amount
    self.date = date
    self.notes = notes ?? ""
  }
  
  init(_ name: String, category: Category, amount: Double, date: Date) {
    id = UUID()
    self.name = name
    self.categoryName = ""
    self.category = category
    self.amount = amount
    self.date = date
    self.notes = ""
  }
}
