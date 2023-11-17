//
//  MonthlyView.swift
//  BudgetManager
//
//  Created by JACK HOGG on 17/11/2023.
//

import Foundation
import SwiftUI
import CoreData

struct MonthlyView: View
{
    @Binding var showing: Page

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.budget, order: .reverse)]) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: []) var transactions: FetchedResults<Transaction>

    @Binding var categoryPageTitle: String
    @State private var selectedTabIndex: Int = 0

    var body: some View
    {
        let transactionsPerMonth = getTransactionPerMonth()
        let months = transactionsPerMonth.keys.sorted(by: >)

        VStack
        {
            HStack
            {
                Text("Budgets")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Spacer()
                Button("Edit") { self.showing = .EditBudgetsPage }
            }
            .padding()

            TabView(selection: self.$selectedTabIndex)
            {
                ForEach(months, id:\.self)
                {
                    month in
                    VStack
                    {
                        HStack
                        {
                            Image(systemName: "chevron.left").foregroundStyle(calculateChevronColor(index: selectedTabIndex, length: months.count, direction: .left))
                            Spacer()
                            Text(month).font(.title2)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundStyle(calculateChevronColor(index: selectedTabIndex, length: months.count, direction: .right))
                        }
                        .padding(.horizontal)
                        BudgetView(showing: $showing, transactions: transactionsPerMonth[month] ?? [], categoryPageTitle: $categoryPageTitle)
                    }
                    .tag(months.firstIndex(of: month)!)
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .onAppear
            {
                self.selectedTabIndex = months.count - 1
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

    func getTransactionPerMonth() -> Dictionary<String, [FetchedResults<Transaction>.Element]>
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        dateFormatter.locale = Locale(identifier: "en_GB")

        return Dictionary(grouping: self.transactions) { (element: Transaction) in
            return dateFormatter.string(from: element.date!)
        }
    }

    enum ChevronDirection
    {
        case left, right
    }
    func calculateChevronColor(index: Int, length: Int, direction: ChevronDirection) -> Color
    {
        if direction == .left && index == 0
        {
            return .gray
        }
        if direction == .right && index == length - 1
        {
            return .gray
        }
        return .black
    }
}
