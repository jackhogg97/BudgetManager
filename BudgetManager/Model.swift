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

struct Transaction: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let date: String
    let amount: Double
    let notes: String
}
