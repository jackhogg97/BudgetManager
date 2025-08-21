//
//  EditBudgetsView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 10/11/2023.
//

import SwiftData
import SwiftUI

struct EditBudgetsView: View {
  @FocusState private var isKeyboardShowing: Bool
  @State private var vm: EditBudgetsViewModel

  init(_ context: ModelContext) {
    let repo = SwiftDataRepository(context: context)
    _vm = State(wrappedValue: EditBudgetsViewModel(context: context, dataRepo: repo))
  }

  var body: some View {
    Form {
      Section("Budget start date") {
        TextField("Start date", value: $vm.startDate, format: .number).keyboardType(.numberPad).focused($isKeyboardShowing)
      }
      ForEach($vm.categories, id: \.id) {
        category in
        HStack {
          Button {
            vm.selectedCategory = category.wrappedValue
          } label: {
            Circle()
              .stroke(Color.primary, lineWidth: 1.0)
              .fill(Color(hex: category.cat_color.wrappedValue) ?? .blue)
              .frame(width: 25.0)
          }
          .contentShape(Rectangle())
          Spacer()
          TextField("Category Name", text: category.name).focused($isKeyboardShowing)
          Spacer()
          HStack {
            Text("£")
            TextField("Budget", value: category.budget, format: .number).keyboardType(.decimalPad).focused($isKeyboardShowing)
          }
        }
      }
      .onDelete(perform: vm.deleteCategory)
      Button("Add category", action: vm.addCategory)
        .sheet(item: $vm.selectedCategory) {
          _ in
          //      ColourPickerView(
          //        selected: Binding(
          //          get: { Color(hex: category.cat_color) ?? .blue },
          //          set: { newColor in
          //            if let index = categoriesToEdit.firstIndex(where: { $0.id == category.id }) {
          //              categoriesToEdit[index].color = newColor
          //            }
          //          }
          //        ),
          //        save: {
          //          if let index = categoriesToEdit.firstIndex(where: { $0.id == category.id }) {
          //            categories[index].cat_color = categoriesToEdit[index].color.toHex() ?? "#0000FF"
          //          }
          //        }
          //      )
          //      .presentationDetents([.medium])
        }
    }
    .onDisappear(perform: vm.save)
    .onAppear(perform: vm.fetchCategories)
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        Spacer()
        Button("Done") {
          isKeyboardShowing = false
        }
      }
    }
  }
}
