//
//  EditTransactionView.swift
//  BudgetManager
//
//  Created by Jack on 15/10/2024.
//

import SwiftData
import SwiftUI

struct EditTransactionView: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.modelContext) private var context

  @Query() private var categories: [Category]
  @Query() private var transactions: [Transaction]

  @State var transaction: TransactionModel

  enum FieldShowing {
    case name, amount, notes
  }

  @FocusState private var fieldShowing: FieldShowing?

  var body: some View {
    VStack(alignment: .leading) {
      Text("Add transaction")
        .font(.title)
        .padding(.vertical)
      
      Form {
        Section {
          HStack {
            Text("Name")
            TextField("Name", text: $transaction.name)
              .multilineTextAlignment(.trailing)
              .focused($fieldShowing, equals: .name)
          }
          HStack {
            Picker("Category", selection: $transaction.category) {
              ForEach(categories, id: \.name) {
                Text($0.name).tag($0.name)
              }
              // Dividers are not rendered in Picker
              Divider().tag(nil as String?)
            }
            .onAppear {
              if transaction.category == nil {
                transaction.category = categories.first?.name
              }
            }
          }
          HStack {
            DatePicker("Date", selection: $transaction.date)
          }
          HStack {
            Text("Amount")
            TextField("Amount", value: $transaction.amount, formatter: numberFormatter())
              .multilineTextAlignment(.trailing)
              .keyboardType(.decimalPad)
              .focused($fieldShowing, equals: .amount)
          }
          HStack {
            TextField("Notes", text: $transaction.notes)
              .frame(height: 150, alignment: .topLeading)
              .focused($fieldShowing, equals: .notes)
          }
        }
        Section {
          Button("Cancel") {
            dismiss()
          }
          Button("Save") {
            addOrEditTransaction()
            dismiss()
          }
          .disabled(isAddButtonDisabled())
        }
      }
      // Doesn't show in sheet inside nav link
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Done", action: doneClicked)
        }
      }
      .padding()
    }
  }

  private func isAddButtonDisabled() -> Bool {
    transaction.name == "" || transaction.category == nil || transaction.amount == 0.0
  }

  private func addOrEditTransaction() {
    if let currentTransaction = transactions.first(where: { $0.id == transaction.id }) {
      currentTransaction.name = transaction.name
      currentTransaction.category = transaction.category ?? ""
      currentTransaction.date = transaction.date
      currentTransaction.amount = transaction.amount
      currentTransaction.notes = transaction.notes
    } else {
//      let newTransaction = Transaction(context: moc)
      let newTransaction = Transaction(
        name: transaction.name,
        category: transaction.category ?? "",
        amount: transaction.amount,
        date: transaction.date,
        notes: transaction.notes
      )
      context.insert(newTransaction)
    }
    try? context.save()
  }

  private func doneClicked() {
    switch fieldShowing {
      case .name:
        fieldShowing = .amount
      default:
        fieldShowing = nil
    }
  }
}

#Preview {
  EditTransactionView(transaction: TransactionModel())
}
