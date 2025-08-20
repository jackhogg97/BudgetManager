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
  var category: String
  var amount: Double
  var date: Date
  var notes: String?

  init(name: String, category: String, amount: Double, date: Date, notes: String?) {
    id = UUID()
    self.name = name
    self.category = category
    self.amount = amount
    self.date = date
    self.notes = notes
  }
}
