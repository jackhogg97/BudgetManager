//
//  TransactionsListView.swift
//  BudgetManager
//
//  Created by Jack on 24/06/2024.
//

import CoreData
import SwiftUI

struct TransactionsListView: View {
  @State private var vm: TransactionsListViewModel

  init(moc: NSManagedObjectContext, days: [String], transactionsByDay: [String: [Transaction]]) {
    _vm = State(wrappedValue: TransactionsListViewModel(moc: moc, days: days, transactionsByDay: transactionsByDay))
  }

  var body: some View {
    List {
      ForEach(vm.days, id: \.self) {
        day in
        Section(header: Text(day)) {
          ForEach(Array(vm.transactionsByDay[day]!.enumerated()), id: \.offset) {
            _, transaction in
            HStack {
              Text(transaction.wrappedName)
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
      EditTransactionView(transaction: TransactionModel(from: transaction))
    }
  }
}

#Preview {
//  TransactionsListView(days: [], transactionsByDay: [:], title: "Example")
}
