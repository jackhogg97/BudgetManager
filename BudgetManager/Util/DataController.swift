//
//  DataController.swift
//  BudgetManager
//
//  Created by JACK HOGG on 10/11/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "DataModel")

  init() {
    container.loadPersistentStores { _, error in
      if let error {
        print("Error loading Core Data: \(error.localizedDescription)")
      }
    }
  }
}
