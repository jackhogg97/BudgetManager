//
//  MonthlySpendView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftData
import SwiftUI

struct MonthlySpendView: View {
  let BAR_MAX_WIDTH = 360.0
  let BAR_MAX_HEIGHT = 35.0
  let BAR_IDEAL_HEIGHT = 35.0

  private let repo: DataRepository
  @State private var vm: MonthlySpendViewModel

  init(_ repo: DataRepository, dateRange: String) {
    _vm = State(wrappedValue: MonthlySpendViewModel(repo, dataRange: dateRange))
    self.repo = repo
  }

  var body: some View {
    GeometryReader {
      _ in
      VStack(alignment: .center, spacing: 0) {
        if vm.categories.isEmpty {
          Text("Click edit to add budgets")
        } else {
          HStack {
            Spacer()
            Button {
              vm.showingDifference.toggle()
              UserDefaults.standard.set(vm.showingDifference, forKey: K.Keys.SHOWING_DIFFERENCE)
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
    .onAppear(perform: vm.fetch)
  }

  var CategoryBars: some View {
    ScrollView {
      ForEach(vm.categories, id: \.id) {
        category in
        NavigationLink {
          TransactionsByDayCategoryView(repo, category: category, transactions: category.transactions, dateRangeLabel: vm.dateRange)
        }
        label: {
          VStack(spacing: 0) {
            HStack {
              Text(category.name)
                .font(.caption)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
              getCategoryLabel(category: category)
                .font(.caption2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)

            let percentFilled = vm.getRowWidth(category: category)
            ZStack(alignment: .leading) {
              bar()
              bar(percentageFilled: percentFilled, colour: Color(hex: category.cat_color) ?? .blue)
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
      // TODO: this causes in 'Invalid frame dimension (negative or non-finite).'
      .frame(maxWidth: BAR_MAX_WIDTH * percentageFilled, idealHeight: BAR_IDEAL_HEIGHT, maxHeight: BAR_MAX_HEIGHT)
      .foregroundColor(colour)
  }

  func getTotalLabel() -> Text {
    vm.showingDifference ? getTotalDifferenceLabel() : getTotalSpentBudgetLabel()
  }

  func getCategoryLabel(category: Category) -> Text {
    vm.showingDifference ?
      getDifferenceLabel(spend: category.currentSpend, budget: category.budget) :
      getSpentBudgetLabel(spend: category.currentSpend, budget: category.budget)
  }

  func getTotalSpentBudgetLabel() -> Text {
    let totalCurrentSpend = vm.categories.reduce(0) { $0 + $1.currentSpend }
    let totalBudget = vm.categories.reduce(0) { $0 + $1.budget }

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
    let totalCurrentSpend = vm.categories.reduce(0) { $0 + $1.currentSpend }
    let totalBudget = vm.categories.reduce(0) { $0 + $1.budget }

    return getDifferenceLabel(spend: totalCurrentSpend, budget: totalBudget)
  }

  func getDifferenceLabel(spend: Double, budget: Double) -> Text {
    let difference = budget - spend
    let color: Color = difference < 0.0 ? .red : .green

    return Text(String(format: "£%.2F", difference)).foregroundColor(color)
  }
}

#Preview {
  MonthlySpendView(
    PreviewContext.MockRepo(),
    dateRange: "15th January - 15th Feburary"
  )
}
