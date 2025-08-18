//
//  MonthlySpendView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import CoreData
import SwiftUI

struct MonthlySpendView: View {
  let BAR_MAX_WIDTH = 360.0
  let BAR_MAX_HEIGHT = 35.0
  let BAR_IDEAL_HEIGHT = 35.0

  @State private var showingDifference: Bool = UserDefaults.standard.bool(forKey: K.Keys.SHOWING_DIFFERENCE)

  var transactions: [FetchedResults<Transaction>.Element]
  var dateRange: String

  @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) private var categories: FetchedResults<Category>

  var body: some View {
    let _ = calculateCurrentSpend()
    GeometryReader {
      _ in
      VStack(alignment: .center, spacing: 0) {
        if categories.isEmpty {
          Text("Click edit to add budgets")
        } else {
          HStack {
            Spacer()
            Button {
              showingDifference.toggle()
              UserDefaults.standard.set(showingDifference, forKey: K.Keys.SHOWING_DIFFERENCE)
            } label: {
              getTotalLabel()
            }.buttonStyle(.plain)
          }
          .padding()
        }
        Spacer()
        CategoryBars
      }
    }
  }

  var CategoryBars: some View {
    ScrollView {
      ForEach(categories, id: \.id) {
        category in
        NavigationLink {
          CategoryView(category: category.wrappedName, transactions: transactions, dateRangeLabel: dateRange)
        }
        label: {
          VStack(spacing: 0) {
            HStack {
              Text(category.name ?? "Unknown")
                .font(.caption)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
              getCategoryLabel(category: category)
                .font(.caption2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)

            let percentFilled = getRowWidth(category: category)
            ZStack(alignment: .leading) {
              bar()
              bar(percentageFilled: percentFilled, colour: Color(hex: category.cat_color ?? "") ?? .blue)
            }
            .padding(.horizontal)
          }
        }.buttonStyle(.plain)
      }
    }
  }

  func bar(percentageFilled: Double = 1.0, colour: Color = .gray) -> some View {
    Rectangle()
      .cornerRadius(5)
      .padding(.vertical, 5)
      .frame(maxWidth: BAR_MAX_WIDTH * percentageFilled, idealHeight: BAR_IDEAL_HEIGHT, maxHeight: BAR_MAX_HEIGHT)
      .foregroundColor(colour)
  }

  func getTotalLabel() -> Text {
    showingDifference ? getTotalDifferenceLabel() : getTotalSpentBudgetLabel()
  }

  func getCategoryLabel(category: Category) -> Text {
    showingDifference ?
      getDifferenceLabel(spend: category.currentSpend, budget: category.budget) :
      getSpentBudgetLabel(spend: category.currentSpend, budget: category.budget)
  }

  func getTotalSpentBudgetLabel() -> Text {
    let totalCurrentSpend = categories.reduce(0) { $0 + $1.currentSpend }
    let totalBudget = categories.reduce(0) { $0 + $1.budget }

    return getSpentBudgetLabel(spend: totalCurrentSpend, budget: totalBudget)
  }

  func getSpentBudgetLabel(spend: Double, budget: Double) -> Text {
    let current = Text(String(format: "£%.2F", spend))

    if spend > budget {
      return current.foregroundColor(.red) +
        Text(String(format: " / £%.2F", budget))
    }

    return current + Text(String(format: " / £%.2F", budget))
  }

  func getTotalDifferenceLabel() -> Text {
    let totalCurrentSpend = categories.reduce(0) { $0 + $1.currentSpend }
    let totalBudget = categories.reduce(0) { $0 + $1.budget }

    return getDifferenceLabel(spend: totalCurrentSpend, budget: totalBudget)
  }

  func getDifferenceLabel(spend: Double, budget: Double) -> Text {
    let difference = budget - spend
    let color: Color = difference < 0.0 ? .red : .green

    return Text(String(format: "£%.2F", difference)).foregroundColor(color)
  }

  func getRowWidth(category: Category) -> Double {
    category.currentSpend / category.budget
  }

  func calculateCurrentSpend() {
    for category in categories {
      category.currentSpend = 0
    }
    for transaction in transactions {
      if let index = categories.firstIndex(where: { $0.name == transaction.category }) {
        categories[index].currentSpend += transaction.amount
      }
    }
  }
}

#Preview {
  MonthlySpendView(
    transactions: [],
    dateRange: "15th January - 15th Feburary"
  )
}
