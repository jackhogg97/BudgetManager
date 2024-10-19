//
//  Constants.swift
//  BudgetManager
//
//  Created by Jack on 15/03/2024.
//

import SwiftUI

enum K
{
  enum Keys
  {
    static let PERIOD_DATE = "periodStartDate"
    // Determins whether the budget labels will show spent/total or +-different
    static let SHOWING_DIFFERENCE = "showingDifference"
  }

  enum Colours
  {
    static let CATEGORIES: [Color] = [.blue, .brown, .cyan, .green, .indigo, .mint, .orange, .pink, .purple, .red, .teal, .yellow]
    static let DEFAULT_CATEGORY: Color = .blue
  }
}
