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
  @Environment(\.managedObjectContext) private var moc

  @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) private var categories: FetchedResults<Category>
  @FetchRequest(sortDescriptors: []) private var transactions: FetchedResults<Transaction>

  @State private var selectedTabIndex: Int = 0
  @State private var showingAddTransaction = false
  @State private var showingDifference = false

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
          // Using empty string here as the string is added to the icon
          Button("", systemImage: displayIcon())
          {
            showingDifference.toggle()
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
                Image(systemName: "chevron.left")
                  .foregroundStyle(calculateChevronColor(
                    index: selectedTabIndex,
                    length: months.count,
                    direction: .left
                  )
                  )
                Spacer()
                NavigationLink
                {
                  DateRangeView(
                    transactions: transactionsPerMonth[month] ?? [],
                    dateRange: month
                  )
                } label: {
                  Text(month).font(.title2).foregroundStyle(.foreground)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(calculateChevronColor(index: selectedTabIndex, length: months.count, direction: .right))
              }
              .padding(.horizontal)
              Spacer()
              BudgetView(showingDifference: $showingDifference, transactions: transactionsPerMonth[month] ?? [], dateRange: month)
            }
            .tag(months.firstIndex(of: month)!)
          }
        }
      }
      .tabViewStyle(.page)
      .onAppear
      {
        selectedTabIndex = months.count - 1
      }
      .toolbar
      {
        ToolbarItemGroup(placement: .bottomBar)
        {
          Spacer()
          NavigationLink
          {
            RecurringTransactions()
          } label: {
            Image(systemName: "repeat")
          }
          Spacer()
          Spacer()
          Button("Add transaction", systemImage: "plus", action: { showingAddTransaction = true })
            .buttonStyle(BorderedButtonStyle())
          Spacer()
          Spacer()
          NavigationLink
          {
            EditBudgetsView()
          } label: {
            Image(systemName: "slider.horizontal.3")
          }
          Spacer()
        }
      }
      .sheet(isPresented: $showingAddTransaction)
      {
        EditTransactionView(transaction: TransactionModel(), saveTransaction: addNewTransaction)
      }
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

  func displayIcon() -> String
  {
    showingDifference ? "plus.forwardslash.minus" : "divide"
  }

  func addNewTransaction(transaction: TransactionModel)
  {
    let newTransaction = Transaction(context: moc)
    newTransaction.id = UUID()
    newTransaction.name = transaction.name
    newTransaction.category = transaction.category
    newTransaction.date = transaction.date
    newTransaction.amount = transaction.amount
    newTransaction.notes = transaction.notes

    try? moc.save()
  }
}
