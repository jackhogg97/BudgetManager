//
//  BudgetView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import CoreData
import SwiftUI

struct BudgetView: View
{
  @Binding var showing: Page

  @Environment(\.managedObjectContext) var moc
  @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) var categories: FetchedResults<Category>

  var transactions: [FetchedResults<Transaction>.Element]
  var categoryPageTitle: String
  var dateRange: String

  var body: some View
  {
    GeometryReader
    {
      _ in

      let BAR_MAX_WIDTH = 360.0
      let BAR_MAX_HEIGHT = 35.0
      let BAR_IDEAL_HEIGHT = 35.0

      VStack(alignment: .center, spacing: 0)
      {
        if categories.isEmpty
        {
          Text("Click edit to add budgets")
        }
        else
        {
          HStack
          {
            Spacer()
            calculateTotal().bold()
          }
          .padding()
        }
        Spacer()
        ScrollView
        {
          ForEach(categories, id: \.id)
          {
            category in
            NavigationLink
            {
              CategoryView(category: category.wrappedName, transactions: transactions, dateRange: dateRange)
            }
            label:
            {
              VStack(spacing: 0)
              {
                HStack
                {
                  Text(category.name ?? "Unknown")
                    .font(.caption)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                  formatBudget(category: category)
                    .font(.caption2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)

                let percentFilled = calculateRowWidth(category: category)
                ZStack(alignment: .leading)
                {
                  Rectangle()
                    .cornerRadius(5)
                    .padding(.vertical, 5)
                    .frame(maxWidth: BAR_MAX_WIDTH, idealHeight: BAR_IDEAL_HEIGHT, maxHeight: BAR_MAX_HEIGHT)
                    .foregroundColor(.gray)
                  Rectangle()
                    .cornerRadius(5)
                    .padding(.vertical, 5)
                    .frame(maxWidth: BAR_MAX_WIDTH * percentFilled, idealHeight: BAR_IDEAL_HEIGHT, maxHeight: BAR_MAX_HEIGHT)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
              }
            }
          }
        }
      }
      .onAppear
      {
        calculateCurrentSpend()
      }
    }
  }

  // TODO: Refactor functions
  func formatBudget(category: Category) -> Text
  {
    let current = Text(String(format: "£%.2F", category.currentSpend))

    if category.currentSpend > category.budget
    {
      return current.foregroundColor(.red) +
        Text(String(format: " / £%.2F", category.budget))
    }
    else
    {
      return current + Text(String(format: " / £%.2F", category.budget))
    }
  }

  func calculateRowWidth(category: Category) -> Double
  {
    category.currentSpend / category.budget
  }

  func calculateCurrentSpend()
  {
    for category in categories
    {
      category.currentSpend = 0
    }
    for transaction in transactions
    {
      if let index = categories.firstIndex(where: { $0.name == transaction.category })
      {
        categories[index].currentSpend += transaction.amount
      }
    }
  }

  func calculateTotal() -> Text
  {
    let totalCurrentSpend = categories.reduce(0) { $0 + $1.currentSpend }
    let totalBudget = categories.reduce(0) { $0 + $1.budget }
    let current = Text(String(format: "£%.2F", totalCurrentSpend))

    if totalCurrentSpend > totalBudget
    {
      return current.foregroundColor(.red) +
        Text(String(format: " / £%.2F", totalBudget))
    }
    else
    {
      return current + Text(String(format: " / £%.2F", totalBudget))
    }
  }
}
