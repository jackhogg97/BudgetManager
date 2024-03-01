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

func numberFormatter() -> NumberFormatter
{
  let formatter = NumberFormatter()
  formatter.zeroSymbol = ""
  return formatter
}
