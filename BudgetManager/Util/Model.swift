//
//  Model.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import Foundation
import SwiftUI

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String
    var date: Date
    var amount: Double
    var notes: String
}

struct Category: Identifiable, Codable
{
    var id = UUID()
    var name: String
    var budget: Double
    var currentSpend: Double
    var color: Color

    enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case budget
        case currentSpend
        case color
    }

    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(budget, forKey: .budget)
        try container.encode(currentSpend, forKey: .currentSpend)

        // Convert Color to RGB components and encode them
        try container.encode(ColorTransformer.toComponents(color: color), forKey: .color)
    }

    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        budget = try container.decode(Double.self, forKey: .budget)
        currentSpend = try container.decode(Double.self, forKey: .currentSpend)

        // Decode RGB components and reconstruct Color
        let rgbComponents = try container.decode([CGFloat].self, forKey: .color)
        color = ColorTransformer.toColor(components: rgbComponents)
    }

    init(id: UUID = UUID(), name: String, budget: Double, currentSpend: Double, color: Color) 
    {
        self.id = id
        self.name = name
        self.budget = budget
        self.currentSpend = currentSpend
        self.color = color
    }
}
