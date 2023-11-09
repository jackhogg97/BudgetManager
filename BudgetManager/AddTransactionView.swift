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
                        Text("Category")
                        TextField("Category", text: $category)
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
                        // Do some things
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
