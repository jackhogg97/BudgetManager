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

@Observable
final class MainViewModel: ObservableObject {
  let dataRepo: SwiftDataRepository
  let PERIOD_START_DATE = UserDefaults.standard.integer(forKey: K.Keys.PERIOD_DATE)

  var selectedTabIndex: Int = 0
  var dataByMonth: [MonthData] = []
  var categories: [Category]
  var transactions: [Transaction]

  var canGoLeft: Bool { selectedTabIndex > 0 }
  var canGoRight: Bool { selectedTabIndex < dataByMonth.count - 1 }

  private let dateFormatter = DateFormatter()

  init(dataRepo: SwiftDataRepository) {
    self.dataRepo = dataRepo
    dateFormatter.dateFormat = "dd MMMM yy"
    categories = dataRepo.fetch(Category.self, sort: [SortDescriptor(\.budget, order: .reverse)])
    transactions = dataRepo.fetch(Transaction.self)
    dataByMonth = getDataByMonth()
    selectedTabIndex = getLastestMonthIndex()
    print(transactions)
  }
  
  func fetch() {
    categories = dataRepo.fetch(Category.self, sort: [SortDescriptor(\.budget, order: .reverse)])
    transactions = dataRepo.fetch(Transaction.self)
  }

  func goLeft() {
    guard canGoLeft else { return }
    selectedTabIndex -= 1
  }

  func goRight() {
    guard canGoRight else { return }
    selectedTabIndex += 1
  }

  private func getDataByMonth() -> [MonthData] {
    let months = Set(transactions.compactMap { $0.date.setDay(day: PERIOD_START_DATE) }).sorted(by: <)
    let ranges: [(start: Date, end: Date)] = months.map { ($0, $0.incrementMonth()) }

    return ranges.map { range in
      let label = self.dateFormatter.string(from: range.start) + " - " + self.dateFormatter.string(from: range.end)
      let transactionsThisMonth = self.transactions.filter { $0.date > range.start && $0.date < range.end }
      return MonthData(label: label, startDate: range.start, endDate: range.end, transactions: transactionsThisMonth)
    }
  }

  private func getLastestMonthIndex() -> Int {
    dataByMonth.count - 1
  }
}
