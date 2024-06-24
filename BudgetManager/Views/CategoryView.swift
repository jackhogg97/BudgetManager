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
    let (days, transactions) = getTransactionsKeyedByDay()
    let title = category + ": " + dateRange

    TransactionsView(days: days, transactions: transactions, title: title)
  }

  func getTransactionsKeyedByDay() -> ([String], [String: [FetchedResults<Transaction>.Element]])
  {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    dateFormatter.locale = Locale(identifier: "en_GB")

    var dates: [String] = []
    let transactionsFromCategory = transactions.filter { $0.category ?? "" == category }
    let sortedTransactions = transactionsFromCategory.sorted(by: { $0.date! > $1.date! })
    let transactionByDate = Dictionary(grouping: sortedTransactions)
    { (element: Transaction) in
      let dateStr = dateFormatter.string(from: element.date!)
      if !dates.contains(dateStr)
      {
        dates.append(dateStr)
      }
      return dateFormatter.string(from: element.date!)
    }

    return (dates, transactionByDate)
  }
}

#Preview
{
  CategoryView(category: "Category Title", transactions: [], dateRange: "15 January - 15 Febuary")
}
