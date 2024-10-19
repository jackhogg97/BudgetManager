//
//  RecurringTransactionsView.swift
//  BudgetManager
//
//  Created by Jack on 18/10/2024.
//

import SwiftUI

struct RecurringTransactions: View
{
  @Environment(\.managedObjectContext) private var moc

  private let recurringTransactions = ["Rent", "Foo"]

  var body: some View
  {
    VStack
    {
      Text("Recurring Transactions").font(.title2)
      Form
      {
        List(recurringTransactions, id: \.self)
        { transaction in
          NavigationLink
          {
            EditTransactionView(transaction: TransactionModel(), saveTransaction: addNewTransaction)
          } label: {
            Text(transaction)
          }
        }
        Section
        {
          NavigationLink
          {
            EditTransactionView(transaction: TransactionModel(), saveTransaction: addNewTransaction)
          } label: {
            Text("Add new transaction").foregroundStyle(.blue).bold()
          }
        }
      }
    }
  }

  func addNewTransaction(transaction: TransactionModel)
  {
    let newTransaction = Transaction(context: moc)
    newTransaction.id = UUID()
    newTransaction.name = transaction.name
    newTransaction.category = transaction.category
    newTransaction.date = transaction.date
    newTransaction.amount = transaction.amount
    newTransaction.notes = transaction.notes

    try? moc.save()
  }
}

#Preview
{
  RecurringTransactions()
}
