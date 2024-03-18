//
//  MainView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 17/11/2023.
//

import CoreData
import Foundation
import SwiftUI

struct MainView: View
{
  @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) var categories: FetchedResults<Category>
  @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>

  @State private var selectedTabIndex: Int = 0
  @State private var showingAddTransaction = false

  private let periodDate = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)

  var body: some View
  {
    let (months, transactionsPerMonth) = getTransactionsPerMonth()

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
              BudgetView(transactions: transactionsPerMonth[month] ?? [], dateRange: month)
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
        Button(action: { showingAddTransaction = true }, label:
          {
            Image(systemName: "plus.circle")
              .resizable()
              .frame(width: 50.0, height: 50.0, alignment: .center)
          })
          .sheet(isPresented: $showingAddTransaction)
          {
            AddTransactionView(showing: $showingAddTransaction)
          }
      }
      .padding(.vertical)
    }
  }

  func getTransactionsPerMonth() -> ([String], [String: [Transaction]])
  {
    let months = Set(transactions.compactMap { $0.date!.setDay(day: periodDate) }).sorted(by: <)
    let ranges: [[Date]] = months.map { month in [month, month.incrementMonth()] }

    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yy"

    var objects: [String: [Transaction]] = [:]
    var keys: [String] = []
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
            keys.append(key)
          }
        }
      }
    }

    return (keys, objects)
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
