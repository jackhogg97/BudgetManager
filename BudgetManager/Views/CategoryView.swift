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
    let (days, transactions) = getTransactionsKeyedByDay(transactions: transactions)
    let title = category + ": " + dateRange

    let transactionsFromCategory = transactions.filter { $1.category ?? "" == category }
    TransactionsView(days: days, transactions: transactions, title: title)
  }
}

#Preview
{
  CategoryView(category: "Category Title", transactions: [], dateRange: "15 January - 15 Febuary")
}
