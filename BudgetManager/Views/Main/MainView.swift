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
  private let repo: DataRepository
  @State private var vm: MainViewModel

  init(_ repo: DataRepository) {
    self.repo = repo
    _vm = State(wrappedValue: MainViewModel(repo))
  }

  var body: some View {
    NavigationStack {
      VStack {
        Title
        Tabview
      }
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          HStack {
            Spacer()
            Button("Recurring transactions", systemImage: "repeat") {}
            Spacer()
            Button("Add transaction", systemImage: "plus") {
              vm.showingAddTransaction = true
            }
            .sheet(isPresented: $vm.showingAddTransaction) {
              EditTransactionView(repo, transaction: nil)
            }
            Spacer()
            NavigationLink { EditBudgetsView(repo) } label: {
              Image(systemName: "slider.horizontal.3")
            }
            Spacer()
          }
          .padding(.horizontal)
        }
      }
    }
    .onChange(of: vm.showingAddTransaction, vm.refresh)
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
                repo,
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
          MonthlySpendView(repo, dateRange: month.label)
        }
        .tag(index)
      }
    }
    .tabViewStyle(.page)
    .animation(.easeInOut, value: vm.selectedTabIndex)
  }
}

#Preview {
  MainView(PreviewContext.MockRepo())
}
