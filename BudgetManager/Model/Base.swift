//
//  Base.swift
//  BudgetManager
//
//  Created by Jack Hogg on 22/08/2025.
//

import Foundation
import SwiftData

protocol BaseModel: PersistentModel {
  var id: UUID { get }
  var name: String { get set }
}
