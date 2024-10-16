//
//  EditBudgetsView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 10/11/2023.
//

import SwiftUI

struct EditBudgetsView: View
{
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  @Environment(\.managedObjectContext) var moc

  @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) var categories: FetchedResults<Category>

  @State private var categoriesToEdit: [CategoryModel] = []
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
          categoriesToEdit.append(CategoryModel(id: UUID(), name: "", budget: 0, color: 0))
        })
      {
        Image(systemName: "plus.circle")
          .resizable()
          .frame(width: 25.0, height: 25.0, alignment: .center)
      }
      .padding(.vertical)
      Section
      {
        Button("Save")
        {
          addOrEditCategory()

          // TODO: validate date
          UserDefaults.standard.setValue(startDate, forKey: K.Keys.PERIOD_DATE)

          try? moc.save()

          presentationMode.wrappedValue.dismiss()
        }
      }
    }
    .onAppear
    {
      categoriesToEdit = categories.map { CategoryModel(from: $0) }
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
    for cat in categoriesToEdit
    {
      if let index = categories.firstIndex(where: { $0.id == cat.id })
      {
        categories[index].id = cat.id
        categories[index].name = cat.name
        categories[index].budget = cat.budget
        categories[index].color = cat.color
      }
      else
      {
        if cat.name != ""
        {
          let categoryToAdd = Category(context: moc)
          categoryToAdd.id = cat.id
          categoryToAdd.name = cat.name
          categoryToAdd.budget = cat.budget
          categoryToAdd.color = cat.color
        }
      }
    }
  }

  // Deleting a category without saving will still delete
  func deleteCategory(at offsets: IndexSet)
  {
    for index in offsets
    {
      categoriesToEdit.remove(at: index)
      if index < categories.count, index >= 0
      {
        moc.delete(categories[index])
      }
    }

    try? moc.save()
  }
}
