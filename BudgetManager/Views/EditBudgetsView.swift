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
          for category in categories
          {
            moc.delete(category)
          }
          try? moc.save()
          showing = .MonthlyView
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
          categoriesToEdit.append(NewCategory(id: UUID(), name: "", budget: 0, color: 0))
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
          showing = .MonthlyView
        }
        Spacer()
        Button("Save")
        {
          for newCategory in categoriesToEdit
          {
            if let index = categories.firstIndex(where: { $0.id == newCategory.id })
            {
              categories[index].id = newCategory.id
              categories[index].name = newCategory.name
              categories[index].budget = newCategory.budget
              categories[index].color = newCategory.color
            }
            else
            {
              let categoryToAdd = Category(context: moc)
              categoryToAdd.id = newCategory.id
              categoryToAdd.name = newCategory.name
              categoryToAdd.budget = newCategory.budget
              categoryToAdd.color = newCategory.color
            }
          }

          try? moc.save()

          showing = .MonthlyView
        }
      }
      .padding(.vertical)
    }
    .onAppear
    {
      categoriesToEdit = categories.map { NewCategory(from: $0) }
    }
    .padding(.horizontal)
  }
}

struct NewCategory
{
  var id: UUID
  var name: String
  var budget: Double
  var color: Float

  init(from: Category)
  {
    id = from.id ?? UUID()
    name = from.wrappedName
    budget = from.budget
    color = from.color
  }

  init(id: UUID, name: String, budget: Double, color: Float)
  {
    self.id = id
    self.name = name
    self.budget = budget
    self.color = color
  }
}
