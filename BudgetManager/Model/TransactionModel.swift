//
//  TransactionModel.swift
//  BudgetManager
//
//  Created by Jack on 15/10/2024.
//

import Foundation

struct TransactionModel
{
  var id: UUID = .init()
  var name: String = ""
  var category: String?
  var date: Date = .init()
  var amount: Double = 0.0
  var notes: String = ""

  init() {}

  init(from transaction: Transaction)
  {
    id = transaction.id ?? UUID()
    name = transaction.wrappedName
    category = transaction.category
    date = transaction.date ?? .init()
    amount = transaction.amount
    notes = transaction.notes ?? ""
  }
}
