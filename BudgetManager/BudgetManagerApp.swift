//
//  BudgetManagerApp.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI
import LocalAuthentication

enum Page 
{
   case BudgetPage, AddTransactionPage, EditBudgetsPage, CategoryPage
}

@main
struct BudgetManagerApp: App 
{
    @State private var isUnlocked = false
    @StateObject private var dataController = DataController()
    @State var showing : Page = .BudgetPage
    @State var categoryPageTitle: String = ""

    var body: some Scene 
    {
        WindowGroup
        {
            ZStack
            {
                if isUnlocked
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
                else
                {
                    VStack
                    {
                        Image(systemName: "lock.square")
                            .resizable()
                            .frame(maxWidth: 100.0, maxHeight: 100.0)
                        Button("Retry")
                        {
                            authenticate()
                        }
                    }
                }
            }
            .onAppear(perform: authenticate)
        }
    }

    func authenticate()
    {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) 
        {
            let reason = "Unlock to view your budgets"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) 
            { success, authenticationError in
                if success
                {
                    isUnlocked = true
                }
            }
        } else 
        {
            // no biometrics
        }
    }

}
