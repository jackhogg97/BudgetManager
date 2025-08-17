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
    let (months, transactionsPerMonth) = vm.getTransactionsPerMonth()

    NavigationStack {
      VStack {
        HStack {
          Text("Budgets")
            .font(.largeTitle).bold()
          Spacer()
        }
        .padding()
        TabView(selection: $vm.selectedTabIndex) {
          ForEach(months, id: \.self) {
            month in
            VStack {
              HStack {
                Image(systemName: "chevron.left")
                  .foregroundStyle(vm.calculateChevronColor(
                    index: vm.selectedTabIndex,
                    length: months.count,
                    direction: .left
                  )
                  )
                Spacer()
                NavigationLink {
                  DateRangeView(
                    transactions: transactionsPerMonth[month] ?? [],
                    dateRange: month
                  )
                } label: {
                  Text(month).font(.title2).foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(vm.calculateChevronColor(index: vm.selectedTabIndex, length: months.count, direction: .right))
              }
              .padding(.horizontal)
              Spacer()
              MonthlySpendView(transactions: transactionsPerMonth[month] ?? [], dateRange: month)
            }
            .tag(months.firstIndex(of: month)!)
          }
        }
      }
      .tabViewStyle(.page)
      .onAppear {
        vm.selectedTabIndex = months.count - 1
      }
      .toolbar {
        ToolbarItemGroup(placement: .bottomBar) {
          Spacer()
          Button("Recurring transactions", systemImage: "repeat") {}
          Spacer()
          Spacer()
          Button("Add transaction", systemImage: "plus", action: { vm.showingAddTransaction = true })
            .buttonStyle(BorderedButtonStyle())
          Spacer()
          Spacer()
          NavigationLink {
            EditBudgetsView()
          } label: {
            Image(systemName: "slider.horizontal.3")
          }
          Spacer()
        }
      }
      .sheet(isPresented: $vm.showingAddTransaction) {
        EditTransactionView(transaction: TransactionModel())
      }
    }
  }
}
