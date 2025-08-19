//
//  MainView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 17/11/2023.
//

import CoreData
import Foundation
import SwiftUI

struct MainView: View {
  @StateObject private var vm: MainViewModel

  init(moc: NSManagedObjectContext) {
    let categoryRepo = CoreDataCategoryRepository(context: moc)
    let transactionRepo = CoreDataTransactionRepository(context: moc)
    _vm = StateObject(wrappedValue: MainViewModel(categoryRepo: categoryRepo, transactionRepo: transactionRepo))
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
      ForEach(vm.dataByMonth, id: \.id) {
        month in
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
          MonthlySpendView(transactions: month.transactions, dateRange: month.label)
        }
        .tag(vm.dataByMonth.firstIndex(of: month)!)
      }
    }
    .tabViewStyle(.page)
  }
}
