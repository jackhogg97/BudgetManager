//
//  MainView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 17/11/2023.
//

import Foundation
import SwiftData
import SwiftUI

struct MainView: View {
  @Environment(\.modelContext) private var modelContext
  @State private var vm: MainViewModel

  init(context: ModelContext) {
    let dataRepo = SwiftDataRepository(context: context)
    _vm = State(wrappedValue: MainViewModel(dataRepo: dataRepo))
  }

  var body: some View {
    NavigationStack {
      VStack {
        Title
        Tabview
      }
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          MainToolbar()
        }
      }
    }
  }

  var Title: some View {
    HStack {
      Text("Budgets")
        .font(.largeTitle).bold()
      Spacer()
    }
    .padding()
  }

  var Tabview: some View {
    TabView(selection: $vm.selectedTabIndex) {
      ForEach(Array(vm.dataByMonth.enumerated()), id: \.offset) {
        index, month in
        VStack {
          HStack {
            if vm.canGoLeft {
              Button(action: { vm.goLeft() }) {
                Image(systemName: "chevron.left")
              }
            }
            Spacer()
            NavigationLink {
              TransactionsByDayMonthView(
                transactions: month.transactions,
                dateRangeLabel: month.label
              )
            } label: {
              Text(month.label).font(.title2).foregroundStyle(.white)
            }
            Spacer()
            if vm.canGoRight {
              Button(action: { vm.goRight() }) {
                Image(systemName: "chevron.right")
              }
            }
          }
          .padding(.horizontal)
          Spacer()
          MonthlySpendView(modelContext, transactions: month.transactions, dateRange: month.label)
        }
        .tag(index)
      }
    }
    .tabViewStyle(.page)
    .animation(.easeInOut, value: vm.selectedTabIndex)
  }
}

#Preview {
  let container = PreviewContext.GetContainer()

  let groceries = Category("Groceries", budget: 200.0, colorHex: "#0000FF")
  let entertainment = Category("Entertainment", budget: 200.0, colorHex: "#0000FF")
  container.mainContext.insert(groceries)
  container.mainContext.insert(entertainment)

  let transaction = Transaction("Big shop", category: groceries, amount: 50.0, date: Date())
  container.mainContext.insert(transaction)

  return MainView(context: container.mainContext)
    .modelContainer(container)
}
