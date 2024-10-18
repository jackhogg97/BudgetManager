//
//  Transactions.swift
//  BudgetManager
//
//  Created by Jack on 16/10/2024.
//

import SwiftUI

// TODO: Refactor this and CategoryView functions
func getTransactionsKeyedByDay(transactions: [Transaction]) -> ([String], [String: [FetchedResults<Transaction>.Element]])
{
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "dd MMMM yyyy"
  dateFormatter.locale = Locale(identifier: "en_GB")

  var dates: [String] = []
  let sortedTransactions = transactions.sorted(by: { $0.date! > $1.date! })
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

// func getTransactionsKeyedByDay() -> ([String], [String: [FetchedResults<Transaction>.Element]])
// {
//  let dateFormatter = DateFormatter()
//  dateFormatter.dateFormat = "dd MMMM yyyy"
//  dateFormatter.locale = Locale(identifier: "en_GB")
//
//  var dates: [String] = []
////  let transactionsFromCategory = transactions.filter { $0.category ?? "" == category }
//  let sortedTransactions = transactionsFromCategory.sorted(by: { $0.date! > $1.date! })
//  let transactionByDate = Dictionary(grouping: sortedTransactions)
//  { (element: Transaction) in
//    let dateStr = dateFormatter.string(from: element.date!)
//    if !dates.contains(dateStr)
//    {
//      dates.append(dateStr)
//    }
//    return dateFormatter.string(from: element.date!)
//  }
//
//  return (dates, transactionByDate)
// }
