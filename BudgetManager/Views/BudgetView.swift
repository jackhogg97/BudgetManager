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

    @State var categories: [Category] = []

    let categoryStore: DataStore<Category>
    let transactionStore: DataStore<Transaction>

    init(showing: Binding<Page>) 
    {
        self._showing = showing
        self.categoryStore = DataStore<Category>(location: "categories")
        self.transactionStore = DataStore<Transaction>(location: "transactions")
    }

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
                            self.categories = self.categoryStore.getData()
                            calculateCurrentSpend(transactions: self.transactionStore.getData())
                        }
                    Spacer()
                    Button("Edit") { self.showing = .EditBudgetsPage }
                }
                .padding()

                if self.categories.isEmpty
                {
                    Text("Click edit to add budgets")
                }
                Spacer()
                ScrollView
                {
                    ForEach(self.$categories)
                    {
                        category in
                        VStack(spacing: 0)
                        {
                            HStack
                            {
                                Text(category.name.wrappedValue)
                                    .font(.caption)
                                    .bold()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                formatBudget(category: category.wrappedValue)
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                            }
                            .padding(.horizontal)

                            let percentFilled = calculateRowWidth(category: category.wrappedValue)
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
                                    .foregroundColor(category.color.wrappedValue)
                            }
                            .padding(.horizontal)
                        }
                    }
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
                .padding(.vertical)

            }

        }
    }

    func formatBudget(category: Category) -> Text {
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

    func calculateCurrentSpend(transactions: [Transaction])
    {
        for transaction in transactions
        {
            if let index = self.categories.firstIndex(where: { $0.name == transaction.category })
            {
                self.categories[index].currentSpend += transaction.amount
            }
        }
    }
}

#Preview {
    BudgetView(showing: .constant(.BudgetPage))
}
