//
//  MainToolbar.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import SwiftData
import SwiftUI

struct MainToolbar: View {
  @State var showingAddTransaction: Bool = false

  private var repo: DataRepository

  init(_ repo: DataRepository) {
    self.repo = repo
  }

  var body: some View {
    HStack {
      Spacer()
      Button("Recurring transactions", systemImage: "repeat") {}
      Spacer()
      Button("Add transaction", systemImage: "plus") {
        showingAddTransaction = true
      }
      .sheet(isPresented: $showingAddTransaction) {
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
