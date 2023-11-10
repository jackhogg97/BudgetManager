//
//  EditBudgets.swift
//  BudgetManager
//
//  Created by JACK HOGG on 09/11/2023.
//

import SwiftUI

struct EditBudgets: View 
{
    @Binding var showing: Page

    var dataStore: DataStore<Category>

    @State private var categories: [Category] = []
    @State private var chosenColor: Color = .blue

    init(showing: Binding<Page>)
    {
        self.dataStore = DataStore<Category>(location: "categories")
        self._categories = State(initialValue: self.dataStore.getData())
        self._showing = showing
    }

    var body: some View
    {
        VStack(alignment: .leading)
        {
            ForEach($categories)
            {
                data in HStack
                {
                    TextField(data.name.wrappedValue, text: data.name)
                    TextField(String(data.budget.wrappedValue), value: data.budget, format: .number)
                    ColorPicker("Colour", selection: data.color)
                }

            }
            Button(action: { categories.append(Category(name: "New Category", budget: 0.0, currentSpend: 0.0, color: .blue))})
            {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 25.0, height: 25.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .padding(.vertical)
            HStack {
                Button("Cancel") {
                    self.showing = .BudgetPage
                }
                Spacer()
                Button("Save") {
                    dataStore.saveData(data: self.categories)
                    self.showing = .BudgetPage
                }
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

#Preview {
    EditBudgets(showing: .constant(.BudgetPage))
}
