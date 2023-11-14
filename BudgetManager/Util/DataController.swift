//
//  DataController.swift
//  BudgetManager
//
//  Created by JACK HOGG on 10/11/2023.
//

import Foundation
import CoreData

class DataController: ObservableObject 
{
    let container = NSPersistentContainer(name: "DataModel");

    init()
    {
        container.loadPersistentStores 
        { description, error in
            if let error = error 
            {
                print("Error loading Core Data: \(error.localizedDescription)")
            }
        }
    }
}
