//
//  BudgetManagerApp.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI

enum Page 
{
   case BudgetPage, AddTransactionPage, EditBudgetsPage
}

@main
struct BudgetManagerApp: App 
{
    @State var showing : Page = .BudgetPage

    var body: some Scene 
    {
        WindowGroup
        {
            ZStack
            {
                switch showing
                {
                    case .BudgetPage:
                        BudgetView(showing: $showing)
                    case .AddTransactionPage:
                        AddTransactionView(showing: $showing)
                    case .EditBudgetsPage:
                        EditBudgets(showing: $showing)
                }

            }
        }
    }
}
