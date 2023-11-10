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

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var date: Date = Date()
    @State private var amount: Double = 0.0
    @State private var notes: String = ""

    private let CategoryStore: DataStore<Category>
    private let TransactionStore: DataStore<Transaction>
    @State private var transactions: [Transaction]

    init(showing: Binding<Page>)
    {
        self._showing = showing
        self.TransactionStore = DataStore<Transaction>(location: "transactions")
        self._transactions = State(initialValue: self.TransactionStore.getData())
        self.CategoryStore = DataStore<Category>(location: "categories")
    }

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
                    }
                    HStack
                    {
                        Picker("Category", selection: $category)
                        {
                            ForEach(CategoryStore.getData(), id: \.name)
                            {
                                Text($0.name)
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
                        TextField("Amount", value: $amount, format: .number)
                    }
                    HStack
                    {
                        Text("Notes")
                        TextField("Notes", text: $notes)
                    }
                }
                Section {
                    Button("Cancel") {
                        self.showing = .BudgetPage
                    }
                    Button("Add") {
                        self.transactions.append(Transaction(name: self.name, category: self.category, date: self.date, amount: self.amount, notes: self.notes))
                        self.TransactionStore.saveData(data: self.transactions)
                        self.showing = .BudgetPage
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    AddTransactionView(showing: .constant(.AddTransactionPage))
}
