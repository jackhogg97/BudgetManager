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
            ForEach(transactions[day]!, id: \.self)
            {
              transaction in
              HStack
              {
                Text(transaction.wrappedName)
                Spacer()
                Text(String(format: "£%.2F", transaction.amount))
              }
            }
            .onDelete
            {
              indexSet in
              if let index = indexSet.first
              {
                let transactionToDelete = transactions[day]![index]
                moc.delete(transactionToDelete)
                try? moc.save()
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
