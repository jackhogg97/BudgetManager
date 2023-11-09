//
//  BudgetView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI

struct BudgetView: View 
{
    @Binding var showing: Page

    var body: some View
    {
        GeometryReader
        {
            geometry in
            VStack(alignment: .center, spacing: 0) 
            {
                HStack
                {
                    Text("Budgets")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                    Spacer()
                    Button("Edit") { self.showing = .EditBudgetsPage }
                }
                .padding(.horizontal)
                
                let categoryStore = DataStore<Category>(location: "categories")

                let rowHeight = geometry.size.height / CGFloat(categoryStore.data.count)

                let labelWidth = geometry.size.width * 0.13
                let valueWidth = geometry.size.width * 0.18

                ForEach(categoryStore.data)
                {
                    category in
                    HStack 
                    {
                        Text(category.name)
                            .font(.caption)
                            .bold()
                            .frame(maxWidth: labelWidth, maxHeight: .infinity, alignment: .leading)

                        let percentFilled = calculateRowWidth(category: category)
                        let maxWidth = 225.0

                        ZStack(alignment: .leading) 
                        {
                            Rectangle()
                                .cornerRadius(5)
                                .padding(.vertical, 5)
                                .frame(maxWidth: maxWidth, maxHeight: 100.0)
                                .foregroundColor(.gray)
                            Rectangle()
                                .cornerRadius(5)
                                .padding(.vertical, 5)
                                .frame(maxWidth: maxWidth * percentFilled, maxHeight: 100.0)
                                .foregroundColor(Color(category.color))
                        }
                        .frame(alignment: .center)

                        Text(formatBudget(category: category))
                            .font(.caption2)
                            .frame(maxWidth: valueWidth, maxHeight: .infinity, alignment: .leading)

                    }
                    .padding(.horizontal)
                    .frame(maxHeight: rowHeight)
                }

                VStack(alignment: .center)
                {
                    Button(action: { self.showing = .AddTransactionPage }, label: 
                    {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50.0, height: 50.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    })
                }

            }.padding(.vertical)

        }
    }

    func formatBudget(category: Category) -> String {
        return String(format: "£%.2F / £%.2F", category.currentSpend, category.budget)
    }
    func calculateRowWidth(category: Category) -> Double {
        return category.currentSpend / category.budget
    }
}

#Preview {
    BudgetView(showing: .constant(.BudgetPage))
}
