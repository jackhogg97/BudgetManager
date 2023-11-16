//
//  BudgetView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI
import CoreData

struct BudgetView: View 
{
    @Binding var showing: Page

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>

    @Binding var categoryPageTitle: String

    var body: some View
    {
        GeometryReader
        {
            geometry in

            let BAR_MAX_WIDTH = 360.0
            let BAR_MAX_HEIGHT = 35.0
            let BAR_IDEAL_HEIGHT = 35.0

            VStack(alignment: .center, spacing: 0)
            {
                HStack
                {
                    Text("Budgets")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(.horizontal)
                        .onAppear {
                            calculateCurrentSpend()
                        }
                    Spacer()
                    Button("Edit") { self.showing = .EditBudgetsPage }
                }
                .padding()

                if categories.isEmpty
                {
                    Text("Click edit to add budgets")
                }
                else
                {
                    HStack
                    {
                        Spacer()
                        calculateTotal().bold()
                    }
                    .padding()
                }
                Spacer()
                ScrollView
                {
                    ForEach(self.categories, id: \.id)
                    {
                        category in
                        VStack(spacing: 0)
                        {
                            HStack
                            {
                                Text(category.name ?? "Unknown")
                                    .font(.caption)
                                    .bold()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                formatBudget(category: category)
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            }
                            .padding(.horizontal)

                            let percentFilled = calculateRowWidth(category: category)
                            ZStack(alignment: .leading)
                            {
                                Rectangle()
                                    .cornerRadius(5)
                                    .padding(.vertical, 5)
                                    .frame(maxWidth: BAR_MAX_WIDTH, idealHeight: BAR_IDEAL_HEIGHT, maxHeight: BAR_MAX_HEIGHT)
                                    .foregroundColor(.gray)
                                Rectangle()
                                    .cornerRadius(5)
                                    .padding(.vertical, 5)
                                    .frame(maxWidth: BAR_MAX_WIDTH * percentFilled, idealHeight: BAR_IDEAL_HEIGHT, maxHeight: BAR_MAX_HEIGHT)
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                        }
                        .onTapGesture
                        {
                            self.categoryPageTitle = category.wrappedName
                            self.showing = .CategoryPage
                        }
                    }
                }

                VStack(alignment: .center)
                {
                    Button(action: { self.showing = .AddTransactionPage }, label: 
                    {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 50.0, height: 50.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    })
                }
                .padding(.vertical)

            }

        }
    }

    // TODO: Refactor functions
    func formatBudget(category: Category) -> Text 
    {
        let current = Text(String(format: "£%.2F", category.currentSpend))

        if category.currentSpend > category.budget {
            return current.foregroundColor(.red) +
                Text(String(format: " / £%.2F", category.budget))
        } else {
            return current + Text(String(format: " / £%.2F", category.budget))
        }
    }

    func calculateRowWidth(category: Category) -> Double {
        return category.currentSpend / category.budget
    }

    func calculateCurrentSpend()
    {
        self.categories.forEach {
            $0.currentSpend = 0
        }
        for transaction in self.transactions
        {
            if let index = self.categories.firstIndex(where: { $0.name == transaction.category })
            {
                self.categories[index].currentSpend += transaction.amount
            }
        }
    }

    func calculateTotal() -> Text
    {
        let totalCurrentSpend = self.categories.reduce(0) { $0 + $1.currentSpend }
        let totalBudget = self.categories.reduce(0) { $0 + $1.budget }
        let current = Text(String(format: "£%.2F", totalCurrentSpend))

        if totalCurrentSpend > totalBudget {
            return current.foregroundColor(.red) +
            Text(String(format: " / £%.2F", totalBudget))
        } else {
            return current + Text(String(format: " / £%.2F", totalBudget))
        }
    }
}

#Preview 
{
    BudgetView(showing: .constant(.BudgetPage), categoryPageTitle: .constant(""))
}
