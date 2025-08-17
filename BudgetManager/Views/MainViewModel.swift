//
//  MainViewModel.swift
//  BudgetManager
//
//  Created by Jack Hogg on 17/08/2025.
//

import CoreData
import Foundation
import SwiftUI

enum ChevronDirection {
  case left, right
}

struct MonthData: Identifiable, Equatable {
  let id: UUID = .init()
  let label: String // "15 January 25 - 15 February 25"
  let startDate: Date
  let endDate: Date
  let transactions: [Transaction]
}

final class MainViewModel: ObservableObject {
  let PERIOD_START_DATE = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)

  @Published var selectedTabIndex: Int = 0
  @Published var showingAddTransaction = false
  @Published var dataByMonth: [MonthData] = []
  @Published var categories: [Category]
  @Published var transactions: [Transaction]

  private let dateFormatter = DateFormatter()

  init(categoryRepo: CategoryRepository, transactionRepo: TransactionRepository) {
    dateFormatter.dateFormat = "dd MMMM yy"
    categories = categoryRepo.fetchCategories()
    transactions = transactionRepo.fetch()
    dataByMonth = getDataByMonth()
  }

  func getChevronColor(index: Int, length: Int, direction: ChevronDirection) -> Color {
    if direction == .left, index == 0 {
      return .black
    }
    if direction == .right, index == length - 1 {
      return .black
    }
    return .gray
  }

  private func getDataByMonth() -> [MonthData] {
    let months = Set(transactions.compactMap { $0.date!.setDay(day: PERIOD_START_DATE) }).sorted(by: <)
    let ranges: [(start: Date, end: Date)] = months.map { ($0, $0.incrementMonth()) }

    return ranges.map { range in
      let label = self.dateFormatter.string(from: range.start) + " - " + self.dateFormatter.string(from: range.end)
      let transactionsThisMonth = self.transactions.filter { $0.date! > range.start && $0.date! < range.end }
      return MonthData(label: label, startDate: range.start, endDate: range.end, transactions: transactionsThisMonth)
    }
  }
}
