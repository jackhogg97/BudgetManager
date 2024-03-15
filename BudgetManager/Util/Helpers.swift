//
//  Helpers.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import Foundation

public extension Category
{
  var wrappedName: String
  {
    name ?? "unknown"
  }
}

public extension Transaction
{
  var wrappedName: String
  {
    name ?? "unknown"
  }
}

public extension Date
{
  func setDay(day: Int) -> Date
  {
    let year = Calendar.current.component(.year, from: self)
    let month = Calendar.current.component(.month, from: self)
    let components = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
    return Calendar.current.date(from: components)!
  }

  func incrementMonth() -> Date
  {
    Calendar.current.date(byAdding: .month, value: 1, to: self)!
  }
}

func numberFormatter() -> NumberFormatter
{
  let formatter = NumberFormatter()
  formatter.zeroSymbol = ""
  return formatter
}
