//
//  BudgetManagerApp.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI

enum Page 
{
   case BudgetPage, AddTransactionPage, EditBudgetsPage, CategoryPage
}

@main
struct BudgetManagerApp: App 
{
    @StateObject private var dataController = DataController()
    @State var showing : Page = .BudgetPage
    @State var categoryPageTitle: String = ""

    var body: some Scene 
    {
        WindowGroup
        {
            ZStack
            {
                switch showing
                {
                    case .BudgetPage:
                        BudgetView(showing: $showing, categoryPageTitle: $categoryPageTitle)
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                    case .AddTransactionPage:
                        AddTransactionView(showing: $showing)
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                    case .EditBudgetsPage:
                        EditBudgetsView(showing: $showing)
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                    case .CategoryPage:
                        CategoryView(showing: $showing, category: $categoryPageTitle)
                            .environment(\.managedObjectContext, dataController.container.viewContext)
                }
            }
        }
    }
}
