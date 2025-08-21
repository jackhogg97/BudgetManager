//
//  TransactionsListView.swift
//  BudgetManager
//
//  Created by Jack on 24/06/2024.
//

import CoreData
import SwiftData
import SwiftUI

struct TransactionsListView: View {
  @Environment(\.modelContext) var context
  @State private var vm: TransactionsListViewModel

  init(context: ModelContext, days: [String], transactionsByDay: [String: [Transaction]]) {
    _vm = State(wrappedValue: TransactionsListViewModel(context: context, days: days, transactionsByDay: transactionsByDay))
  }

  var body: some View {
    List {
      ForEach(vm.days, id: \.self) {
        day in
        Section(header: Text(day)) {
          ForEach(vm.transactionsByDay[day]!) {
            transaction in
            HStack {
              Text(transaction.name)
              Spacer()
              Text(String(format: "£%.2F", transaction.amount))
            }
            .swipeActions(allowsFullSwipe: false) {
              Button("Edit", systemImage: "pencil") {
                vm.selectedTransaction = transaction
              }
              Button("Delete", systemImage: "trash.fill", role: .destructive) {
                vm.deleteTransaction(transaction)
              }
            }
          }
        }
      }
    }
    .listStyle(.plain)
    .sheet(item: $vm.selectedTransaction) {
      transaction in
      EditTransactionView(context, transaction: transaction)
    }
  }
}

#Preview {
//  TransactionsListView(days: [], transactionsByDay: [:], title: "Example")
}
