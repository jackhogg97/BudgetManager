//
//  Helpers.swift
//  BudgetManager
//
//  Created by JACK HOGG on 08/11/2023.
//

import SwiftUI

public extension Date {
  func setDay(day: Int) -> Date {
    let year = Calendar.current.component(.year, from: self)
    let month = Calendar.current.component(.month, from: self)
    let components = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
    return Calendar.current.date(from: components)!
  }

  func incrementMonth() -> Date {
    Calendar.current.date(byAdding: .month, value: 1, to: self)!
  }
}

func numberFormatter() -> NumberFormatter {
  let formatter = NumberFormatter()
  formatter.zeroSymbol = ""
  formatter.numberStyle = .decimal
  return formatter
}

extension Color {
  func toHex() -> String? {
    let uic = UIColor(self)
    guard let components = uic.cgColor.components, components.count >= 3
    else {
      print("Colour components not found")
      return nil
    }

    let (r, g, b) = (Float(components[0]), Float(components[1]), Float(components[2]))

    var a = Float(1.0)
    if components.count >= 4 {
      a = Float(components[3])
    }

    if a != Float(1.0) {
      return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
    } else {
      return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
  }

  init?(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

    var rgb: UInt64 = 0

    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 1.0

    let length = hexSanitized.count

    guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

    if length == 6 {
      r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
      g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
      b = CGFloat(rgb & 0x0000FF) / 255.0
    } else if length == 8 {
      r = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
      g = CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0
      b = CGFloat((rgb & 0x0000_FF00) >> 8) / 255.0
      a = CGFloat(rgb & 0x0000_00FF) / 255.0
    } else {
      print("Unable to initialise Color from hex")
      return nil
    }

    self.init(red: r, green: g, blue: b, opacity: a)
  }
}

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}
