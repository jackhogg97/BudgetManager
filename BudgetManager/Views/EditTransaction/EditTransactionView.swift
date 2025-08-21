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
  
  enum FieldShowing {
    case name, amount, notes
  }
  @FocusState private var fieldShowing: FieldShowing?
  
  @State var vm: EditTransactionViewModel
  
  init(_ context: ModelContext, transaction: Transaction?) {
    let repo = SwiftDataRepository(context: context)
    _vm = State(wrappedValue: EditTransactionViewModel(context, repo: repo, transaction: transaction))
  }

  var body: some View {
    VStack(alignment: .center) {
      Text("Add transaction")
        .font(.title)
      Form {
        Section {
          HStack {
            Text("Name")
            TextField("Name", text: $vm.currentTransaction.name)
              .multilineTextAlignment(.trailing)
              .focused($fieldShowing, equals: .name)
          }
          HStack {
            Picker("Category", selection: $vm.currentTransaction.category) {
              ForEach(vm.categories, id: \.name) { category in
                let _ = print(category)
                Text(category.name).tag(Optional(category))
              }
              // Dividers are not rendered in Picker
              Divider().tag(nil as String?)
            }
          }
          HStack {
            DatePicker("Date", selection: $vm.currentTransaction.date)
          }
          HStack {
            Text("Amount")
            TextField("Amount", value: $vm.currentTransaction.amount, formatter: numberFormatter())
              .multilineTextAlignment(.trailing)
              .keyboardType(.decimalPad)
              .focused($fieldShowing, equals: .amount)
          }
          HStack {
            TextField("Notes", text: $vm.currentTransaction.notes)
              .frame(height: 150, alignment: .topLeading)
              .focused($fieldShowing, equals: .notes)
          }
        }
        Section {
          Button("Cancel") {
            dismiss()
          }
          Button("Save") {
            vm.saveTransaction()
            dismiss()
          }
          .disabled(vm.isSaveButtonDisabled())
        }
      }
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Done", action: doneClicked)
        }
      }
      .padding()
    }
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

//#Preview {
//  EditTransactionView(transaction: TransactionModel())
//}
