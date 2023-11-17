//
//  EditBudgetsView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 10/11/2023.
//

import SwiftUI

struct EditBudgetsView: View 
{
    @Binding var showing: Page

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) var categories: FetchedResults<Category>

    @State private var categoriesToEdit: [NewCategory] = []

    var body: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                Spacer()
                Button("Delete all")
                {
                    self.categories.forEach {
                        self.moc.delete($0)
                    }
                    try? self.moc.save()
                    self.showing = .BudgetPage
                }
                .foregroundStyle(.red)
            }
            Spacer()
            ForEach($categoriesToEdit, id: \.id)
            {
                category in
                HStack
                {
                    TextField("Category Name", text: category.name)
                    TextField("Budget", value: category.budget, format: .number).keyboardType(.numbersAndPunctuation)
//                    ColorPicker("Color", selection: categoryEdit.color)
                }
            }
            Button(action:
            {
                self.categoriesToEdit.append(NewCategory(id: UUID(), name: "", budget: 0, color: 0))
            })
            {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 25.0, height: 25.0, alignment: .center)
            }
            .padding(.vertical)
            Spacer()

            HStack 
            {
                Button("Cancel") 
                {
                    self.showing = .BudgetPage
                }
                Spacer()
                Button("Save") 
                {
                    for newCategory in self.categoriesToEdit {
                        if let index = self.categories.firstIndex(where: { $0.id == newCategory.id }) {
                            self.categories[index].id = newCategory.id
                            self.categories[index].name = newCategory.name
                            self.categories[index].budget = newCategory.budget
                            self.categories[index].color = newCategory.color
                        } else {
                            let categoryToAdd = Category(context: moc)
                            categoryToAdd.id = newCategory.id
                            categoryToAdd.name = newCategory.name
                            categoryToAdd.budget = newCategory.budget
                            categoryToAdd.color = newCategory.color
                        }
                    }

                    try? self.moc.save()

                    self.showing = .BudgetPage
                }
            }
            .padding(.vertical)
        }
        .onAppear
        {
            self.categoriesToEdit = self.categories.map { NewCategory(from: $0) }
        }
        .padding(.horizontal)
    }
}

struct NewCategory {
    var id: UUID
    var name: String
    var budget: Double
    var color: Float

    init(from: Category) {
        self.id = from.id ?? UUID()
        self.name = from.wrappedName
        self.budget = from.budget
        self.color = from.color
    }

    init(id: UUID, name: String, budget: Double, color: Float) {
        self.id = id
        self.name = name
        self.budget = budget
        self.color = color
    }
}
