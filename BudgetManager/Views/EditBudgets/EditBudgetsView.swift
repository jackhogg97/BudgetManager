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

  init(_ repo: DataRepository) {
    _vm = State(wrappedValue: EditBudgetsViewModel(repo))
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
          category in
          ColourPickerView(
            selected: Binding(
              get: { Color(hex: category.cat_color) ?? .blue },
              set: { vm.setCategoryColour(category, colour: $0) }
            ),
          )
          .presentationDetents([.medium])
        }
    }
    .onAppear(perform: vm.fetchCategories)
    .onDisappear(perform: vm.save)
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

#Preview {
  EditBudgetsView(PreviewContext.MockRepo())
}
