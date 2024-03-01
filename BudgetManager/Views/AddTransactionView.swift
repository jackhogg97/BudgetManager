//
//  AddTransactionView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI

struct AddTransactionView: View 
{
    @Binding var showing: Page

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>

    @State private var name: String = ""
    @State private var category: String?
    @State private var date: Date = Date()
    @State private var amount: Double = 0.0
    @State private var notes: String = ""

    var body: some View
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
                    }
                    HStack
                    {
                        Picker("Category", selection: $category)
                        {
                            ForEach(self.categories, id: \.name)
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
                    }
                    HStack
                    {
                        TextField("Notes", text: $notes)
                            .frame(height: 150, alignment: .topLeading)
                    }
                }
                Section {
                    Button("Cancel") {
                        returnToParentView()
                    }
                    Button("Add") {
                        addNewTransaction()
                        returnToParentView()
                    }
                    .disabled(isAddButtonDisabled())
                }
                Section {
                    Button("Delete all transactions", role: .destructive) {
                        deleteAllTransactions()
                        returnToParentView()
                    }
                    .disabled(true)
                }
            }
        }
        .padding()
    }

  private func returnToParentView()
  {
    self.showing = .MonthlyView
  }

  private func isAddButtonDisabled() -> Bool
  {
    return self.name == "" || self.category == nil || self.amount == 0.0
  }

  private func addNewTransaction()
  {
    let newTransaction = Transaction(context: self.moc)
    newTransaction.id = UUID()
    newTransaction.name = $name.wrappedValue
    newTransaction.category = $category.wrappedValue
    newTransaction.date = $date.wrappedValue
    newTransaction.amount = $amount.wrappedValue
    newTransaction.notes = $notes.wrappedValue
    try? self.moc.save()
  }

  private func deleteAllTransactions()
  {
    self.transactions.forEach {
      self.moc.delete($0)
    }
    try? self.moc.save()
  }
}

#Preview {
    AddTransactionView(showing: .constant(.AddTransactionPage))
}
