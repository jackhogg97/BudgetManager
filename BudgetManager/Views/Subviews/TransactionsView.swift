//
//  TransactionsView.swift
//  BudgetManager
//
//  Created by Jack on 24/06/2024.
//

import SwiftUI

struct TransactionsView: View
{
  @Environment(\.managedObjectContext) var moc

  // Swift does not have an ordered dictionary
  var (days, transactions): ([String], [String: [FetchedResults<Transaction>.Element]])
  var title: String

  @State private var showingEditTransaction = false

  var body: some View
  {
    VStack(alignment: .leading)
    {
      HStack
      {
        Spacer()
        Text(title).font(.title3)
        Spacer()
      }
      Spacer()
      List
      {
        ForEach(days, id: \.self)
        {
          day in
          Section(header: Text(day))
          {
            ForEach(Array(transactions[day]!.enumerated()), id: \.offset)
            {
              index, transaction in
              HStack
              {
                Text(transaction.wrappedName)
                Spacer()
                Text(String(format: "£%.2F", transaction.amount))
              }
              .swipeActions(allowsFullSwipe: false)
              {
                Button
                {
                  showingEditTransaction.toggle()
                } label: {
                  Label("Edit", systemImage: "pencil")
                }
                Button(role: .destructive)
                {
                  let transactionToDelete = transactions[day]![index]
                  moc.delete(transactionToDelete)
                  try? moc.save()
                } label: {
                  Label("Delete", systemImage: "trash.fill")
                }
              }
              .sheet(isPresented: $showingEditTransaction)
              {
                EditTransactionView(transaction: TransactionModel(from: transaction))
              }
            }
          }
        }
      }
      .listStyle(.plain)
    }
  }
}

#Preview
{
  TransactionsView(days: [], transactions: [:], title: "Example")
}
