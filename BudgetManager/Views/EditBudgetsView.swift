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
  @State private var startDate: Int = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)

  @FocusState private var isKeyboardShowing: Bool

  var body: some View
  {
    Form
    {
      Section("Budget start date")
      {
        TextField("Start date", value: $startDate, format: .number).keyboardType(.numberPad).focused($isKeyboardShowing)
      }
      ForEach($categoriesToEdit, id: \.id)
      {
        category in
        HStack
        {
          TextField("Category Name", text: category.name).focused($isKeyboardShowing)
          TextField("Budget", value: category.budget, format: .number).keyboardType(.decimalPad).focused($isKeyboardShowing)
        }
      }
      .onDelete(perform: deleteCategory)
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
          addOrEditCategory()

          // TODO: validate date
          UserDefaults.standard.setValue(startDate, forKey: K.Keys.PERIOD_DATE)

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
    .toolbar
    {
      ToolbarItemGroup(placement: .keyboard)
      {
        Spacer()
        Button("Done")
        {
          isKeyboardShowing = false
        }
      }
    }
    .padding(.horizontal)
  }

  func addOrEditCategory()
  {
    for newCategory in categories
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
  }

  func deleteCategory(at offsets: IndexSet)
  {
    for index in offsets
    {
      guard index < categories.count, index >= 0
      else
      {
        let _ = categoriesToEdit.popLast()
        return
      }
      let cat = categories[index]
      print("attempting delete")
      moc.delete(cat)
    }

    try? moc.save()
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
