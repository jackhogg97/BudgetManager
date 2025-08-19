//
//  TransactionsListView.swift
//  BudgetManager
//
//  Created by Jack on 24/06/2024.
//

import SwiftUI

struct TransactionsListView: View {
  @Environment(\.managedObjectContext) var moc

  // Swift does not have an ordered dictionary
  var (days, transactionsByDay): ([String], [String: [Transaction]])
  var title: String

  @State private var showingEditTransaction = false
  @State private var selectedTransaction: Transaction?

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Spacer()
        Text(title).font(.title3)
        Spacer()
      }
      Spacer()
      List {
        ForEach(days, id: \.self) {
          day in
          Section(header: Text(day)) {
            ForEach(Array(transactionsByDay[day]!.enumerated()), id: \.offset) {
              index, transaction in
              HStack {
                Text(transaction.wrappedName)
                Spacer()
                Text(String(format: "£%.2F", transaction.amount))
              }
              .swipeActions(allowsFullSwipe: false) {
                Button {
                  selectedTransaction = transaction
                } label: {
                  Label("Edit", systemImage: "pencil")
                }
                Button(role: .destructive) {
                  let transactionToDelete = transactionsByDay[day]![index]
                  moc.delete(transactionToDelete)
                  try? moc.save()
                } label: {
                  Label("Delete", systemImage: "trash.fill")
                }
              }
            }
          }
        }
      }
      .listStyle(.plain)
      .sheet(item: $selectedTransaction) {
        transaction in
        EditTransactionView(transaction: TransactionModel(from: transaction))
      }
    }
  }
}

#Preview {
  TransactionsListView(days: [], transactionsByDay: [:], title: "Example")
}
