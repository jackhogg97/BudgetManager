//
//  AddTransactionView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI

struct AddTransactionView: View
{
  @Binding var showing: Bool

  @Environment(\.managedObjectContext) var moc
  @FetchRequest(sortDescriptors: []) var categories: FetchedResults<Category>
  @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>

  @State private var name: String = ""
  @State private var category: String?
  @State private var date: Date = .init()
  @State private var amount: Double = 0.0
  @State private var notes: String = ""

  enum FieldShowing
  {
    case name, amount, notes
  }

  @FocusState private var fieldShowing: FieldShowing?

  var body: some View
  {
    NavigationStack
    {
      VStack(alignment: .leading)
      {
        Text("Add transaction")
          .font(.title)
          .padding(.vertical)

        Form
        {
          Section
          {
            HStack
            {
              Text("Name")
              TextField("Name", text: $name)
                .multilineTextAlignment(.trailing)
                .focused($fieldShowing, equals: .name)
            }
            HStack
            {
              Picker("Category", selection: $category)
              {
                ForEach(categories, id: \.name)
                {
                  Text($0.name!).tag($0.name)
                }
              }
            }
            HStack
            {
              DatePicker("Date", selection: $date)
            }
            HStack
            {
              Text("Amount")
              TextField("Amount", value: $amount, formatter: numberFormatter())
                .multilineTextAlignment(.trailing)
                .keyboardType(.decimalPad)
                .focused($fieldShowing, equals: .amount)
            }
            HStack
            {
              TextField("Notes", text: $notes)
                .frame(height: 150, alignment: .topLeading)
                .focused($fieldShowing, equals: .notes)
            }
          }
          Section
          {
            Button("Cancel")
            {
              returnToParentView()
            }
            Button("Add")
            {
              addNewTransaction()
              returnToParentView()
            }
            .disabled(isAddButtonDisabled())
          }
          Section
          {
            Button("Delete all transactions", role: .destructive)
            {
              deleteAllTransactions()
              returnToParentView()
            }
            .disabled(true)
          }
        }
        .toolbar
        {
          ToolbarItemGroup(placement: .keyboard)
          {
            Spacer()
            Button("Done", action: doneClicked)
          }
        }
      }
      .padding()
    }
  }

  private func returnToParentView()
  {
    showing = false
  }

  private func isAddButtonDisabled() -> Bool
  {
    name == "" || category == nil || amount == 0.0
  }

  private func addNewTransaction()
  {
    let newTransaction = Transaction(context: moc)
    newTransaction.id = UUID()
    newTransaction.name = $name.wrappedValue
    newTransaction.category = $category.wrappedValue
    newTransaction.date = $date.wrappedValue
    newTransaction.amount = $amount.wrappedValue
    newTransaction.notes = $notes.wrappedValue
    try? moc.save()
  }

  private func deleteAllTransactions()
  {
    for transaction in transactions
    {
      moc.delete(transaction)
    }
    try? moc.save()
  }

  private func doneClicked()
  {
    switch fieldShowing
    {
      case .name:
        fieldShowing = .amount
      default:
        fieldShowing = nil
    }
  }
}

#Preview
{
  AddTransactionView(showing: .constant(true))
}
