//
//  CategoryView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 16/11/2023.
//

import SwiftUI

struct CategoryView: View
{
  @Environment(\.managedObjectContext) var moc

  var category: String
  var transactions: [Transaction]
  var dateRange: String

  var body: some View
  {
    VStack(alignment: .leading)
    {
      HStack
      {
        Spacer()
        Text(category + ": " + dateRange).font(.title3)
        Spacer()
      }
      Spacer()
      let transactionsFromCategory = getTransactionsKeyedByDay()
      List
      {
        ForEach(transactionsFromCategory.keys.sorted(by: >), id: \.self)
        {
          day in
          Section(header: Text(day))
          {
            ForEach(transactionsFromCategory[day]!, id: \.self)
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
                let transactionToDelete = transactionsFromCategory[day]![index]
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

  func getTransactionsKeyedByDay() -> [String: [FetchedResults<Transaction>.Element]]
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    dateFormatter.locale = Locale(identifier: "en_GB")

    let transactionsFromCategory = transactions.filter { $0.category ?? "" == category }
    return Dictionary(grouping: transactionsFromCategory)
    { (element: Transaction) in
      dateFormatter.string(from: element.date!)
    }
  }
}

#Preview
{
  CategoryView(category: "Category Title", transactions: [], dateRange: "15 January - 15 Febuary")
}
