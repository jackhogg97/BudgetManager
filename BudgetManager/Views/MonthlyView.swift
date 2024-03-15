//
//  MonthlyView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 17/11/2023.
//

import CoreData
import Foundation
import SwiftUI

struct MonthlyView: View
{
  @Binding var showing: Page

  @Environment(\.managedObjectContext) var moc
  @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) var categories: FetchedResults<Category>
  @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>

  @Binding var categoryPageTitle: String
  @State private var selectedTabIndex: Int = 0

  private let periodDate = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)

  var body: some View
  {
    let transactionsPerMonth = getTransactionsPerMonth()
    let months = transactionsPerMonth.keys.sorted(by: >)

    NavigationStack
    {
      VStack
      {
        HStack
        {
          Text("Budgets")
            .font(.largeTitle).bold()
          Spacer()
          NavigationLink
          {
            EditBudgetsView()
          } label: {
            Text("Edit")
          }
        }
        .padding()
        TabView(selection: $selectedTabIndex)
        {
          ForEach(months, id: \.self)
          {
            month in
            VStack
            {
              HStack
              {
                Image(systemName: "chevron.left").foregroundStyle(calculateChevronColor(index: selectedTabIndex, length: months.count, direction: .left))
                Spacer()
                Text(month).font(.title2)
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(calculateChevronColor(index: selectedTabIndex, length: months.count, direction: .right))
              }
              .padding(.horizontal)
              Spacer()
              BudgetView(showing: $showing, transactions: transactionsPerMonth[month] ?? [], categoryPageTitle: categoryPageTitle, dateRange: month)
            }
            .tag(months.firstIndex(of: month)!)
          }
        }
      }
      .tabViewStyle(.page)
      .indexViewStyle(.page(backgroundDisplayMode: .interactive))
      .onAppear
      {
        selectedTabIndex = months.count - 1
      }
      VStack(alignment: .center)
      {
        Button(action: { showing = .AddTransactionPage }, label:
          {
            Image(systemName: "plus.circle")
              .resizable()
              .frame(width: 50.0, height: 50.0, alignment: .center)
          })
      }
      .padding(.vertical)
    }
  }

  func getTransactionsPerMonth() -> [String: [Transaction]]
  {
    let months = Set(transactions.compactMap { $0.date!.setDay(day: periodDate) }).sorted()
    let ranges: [[Date]] = months.map { month in [month, month.incrementMonth()] }

    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM"

    var objects: [String: [Transaction]] = [:]
    for range in ranges
    {
      let key = formatter.string(from: range[0]) + " - " + formatter.string(from: range[1])
      for transaction in transactions
      {
        if transaction.date! > range[0], transaction.date! < range[1]
        {
          if var transactionInMonth = objects[key]
          {
            transactionInMonth.append(transaction)
            objects[key] = transactionInMonth
          }
          else
          {
            objects[key] = [transaction]
          }
        }
      }
    }

    return objects
  }

  enum ChevronDirection
  {
    case left, right
  }

  func calculateChevronColor(index: Int, length: Int, direction: ChevronDirection) -> Color
  {
    if direction == .left, index == 0
    {
      return .black
    }
    if direction == .right, index == length - 1
    {
      return .black
    }
    return .gray
  }
}
