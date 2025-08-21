//
//  MainToolbar.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import SwiftUI

struct MainToolbar: View {
  @Environment(\.modelContext) var context
  @State var showingAddTransaction: Bool = false

  var body: some View {
    HStack {
      Spacer()
      Button("Recurring transactions", systemImage: "repeat") {}
      Spacer()
      Button("Add transaction", systemImage: "plus") {
        showingAddTransaction = true
      }
      .sheet(isPresented: $showingAddTransaction) {
        EditTransactionView(transaction: TransactionModel())
      }
      Spacer()
      NavigationLink { EditBudgetsView(context) } label: {
        Image(systemName: "slider.horizontal.3")
      }
      Spacer()
    }
    .padding(.horizontal)
  }
}
