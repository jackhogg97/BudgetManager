//
//  Model.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable {
    var id = UUID()
    var name: String
    var budget: Double
    var currentSpend: Double
    var color: String
}

var testData: [Category] = [
    Category(name: "Bills", budget: 1000, currentSpend: 800, color: ".blue"),
    Category(name: "Food", budget: 500, currentSpend: 100, color: ".red"),
    Category(name: "Savings", budget: 200, currentSpend: 100, color: ".green"),
]

func largestCategory(categories: [Category]) -> Double {
    var largest = 0.0

    for cat in categories {
        if cat.currentSpend > largest {
            largest = cat.currentSpend
        }
    }
    return largest
}

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String
    var date: Date
    var amount: Double
    var notes: String
}

struct CategorySpend {
    let Name: String
    let Spend: Double
}

func calculateCurrentSpend(transactions: [Transaction], categories: inout [Category]) -> [Category]
{
    print(transactions)
    print(categories)
    for transaction in transactions
    {
        if let index = categories.firstIndex(where: { $0.name == transaction.category }) 
        {
            categories[index].currentSpend += transaction.amount
        }
    }
    print(categories)
    return categories
}
